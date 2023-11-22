import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { AppleClientAuthBody } from './apple.client.auth.body.dto';
import { ConfigService } from '@nestjs/config';
import { map, mergeMap } from 'rxjs';
import { instanceToPlain, plainToInstance } from 'class-transformer';
import {
  AppleIdentityTokenPublicKey,
  AppleIdentityTokenPublicKeys,
} from './apple.identity.token.public.keys.response.dto';
import { AppleIdentityTokenPayload } from './apple.identity.token.payload.dto';
import { createPublicKey, randomUUID } from 'crypto';
import { AppleIdentityTokenHeader } from './apple.identity.token.header.dto';
import { Repository } from 'typeorm';
import { AppleAuth } from 'src/entities/apple.auth.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/entities/user.entity';
import { Authentication } from '../authentication.dto';
import { Transactional } from 'src/utils/transactional.decorator';
import { AppleClientRevokeBody } from './apple.client.revoke.body.dto';
import { AppleAuthTokenBody } from './apple.auth.token.body.dto';
import { AppleAuthRevokeBody } from './apple.auth.revoke.body.dto';
import { AppleAuthTokenResponse } from './apple.auth.token.response.dto';
import { AppleClientAuthResponse } from './apple.client.auth.response.dto';

/**
 * ### AppleAuthService
 * - 애플 OAuth2 로그인(모바일 기기의 플로우만 고려했습니다.)을 구현합니다.
 * - 아직 테스트가 필요합니다.
 * @author NOSSOH, JIJIHUNY
 */
@Injectable()
export class AppleAuthService {
  constructor(
    private readonly httpService: HttpService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    @InjectRepository(AppleAuth)
    private readonly appleAuthRepository: Repository<AppleAuth>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async auth({ identityToken }: AppleClientAuthBody) {
    const { keys: keysRequest } = this.configService.get('apple.auth');
    const { alg, kid } = this.extractJwtHeader(identityToken);
    return this.httpService.request(keysRequest).pipe(
      /**
       * 1. 우선 https://appleid.apple.com/auth/oauth2/v2/keys로부터
       * public key 배열을 가져옵니다. 그리고 identity_token과 alg, kid 값을 비교해
       * 동일한 키 하나를 찾아냅니다.
       */
      map(({ data }) => {
        return plainToInstance(
          AppleIdentityTokenPublicKeys,
          data,
        ).findMatchedKeyBy(alg, kid);
      }),
      /**
       * 2. 다음으로 public key의 e(exponent) n(modulus)를 이용해 JWK(Json Web Key)를 생성하고
       * encoding합니다.
       */
      map((key: AppleIdentityTokenPublicKey & { [key: string]: any }) => {
        return createPublicKey({ key, format: 'jwk' }).export({
          type: 'pkcs1',
          format: 'pem',
        });
      }),
      /**
       * 3. public key를 가지고 identityToken을 검증합니다.
       */
      //TODO: validation
      map((publicKey) => {
        return plainToInstance(
          AppleIdentityTokenPayload,
          this.jwtService.verify(identityToken, { secret: publicKey }),
        );
      }),
      map(async (result) => {
        return await this.authInternal(result);
      }),
    );
  }

  async revoke({ identityToken, authorizationCode }: AppleClientRevokeBody) {
    const {
      token: tokenRequest,
      key: keysRequest,
      revoke: revokeRequest,
    } = this.configService.get('apple.auth');
    const { alg, kid } = this.extractJwtHeader(identityToken);
    const { payload, header, secret } = this.configService.get(
      'apple.client_secret',
    );
    const clientSecret = this.jwtService.sign(payload, { header, secret });
    return this.httpService.request(keysRequest).pipe(
      map(({ data }) => {
        return plainToInstance(
          AppleIdentityTokenPublicKeys,
          data,
        ).findMatchedKeyBy(alg, kid);
      }),
      /**
       * 2. 다음으로 public key의 e(exponent) n(modulus)를 이용해 JWK(Json Web Key)를 생성하고
       * encoding합니다.
       */
      map((key: AppleIdentityTokenPublicKey & { [key: string]: any }) => {
        return createPublicKey({ key, format: 'jwk' }).export({
          type: 'pkcs1',
          format: 'pem',
        });
      }),
      /**
       * 3. public key를 가지고 identityToken을 검증합니다.
       */
      //TODO: validation
      map((publicKey) => {
        return plainToInstance(
          AppleIdentityTokenPayload,
          this.jwtService.verify(identityToken, { secret: publicKey }),
        );
      }),
      map((identityTokenPayload) => {
        this.delete(identityTokenPayload);
        return plainToInstance(AppleAuthTokenBody, {
          client_secret: clientSecret,
          client_id: payload.iss,
          code: authorizationCode,
        }).toString();
      }),
      mergeMap((data) => {
        return this.httpService.request({ ...tokenRequest, data });
      }),
      map(({ data }) => {
        return plainToInstance(AppleAuthTokenResponse, data).refresh_token;
      }),
      map((refreshToken) => {
        return plainToInstance(AppleAuthRevokeBody, {
          client_id: payload.iss,
          client_secret: clientSecret,
          token: refreshToken,
          token_type_hint: 'refresh_token',
        }).toString();
      }),
      mergeMap((tokenBody) => {
        return this.httpService.request({ ...revokeRequest, data: tokenBody });
      }),
    );
  }

  @Transactional()
  private async authInternal(payload: AppleIdentityTokenPayload) {
    if (!(await this.isUserExists(payload))) {
      return await this.signup(payload);
    } else {
      return await this.signin(payload);
    }
  }

  /**
   *
   * @param
   * @returns
   */
  private async isUserExists({ sub }: AppleIdentityTokenPayload) {
    return await this.appleAuthRepository.exist({
      where: {
        appleId: sub,
      },
    });
  }

  private async signup({ sub, email }: AppleIdentityTokenPayload) {
    const user = await this.userRepository.save(
      {
        email,
        password: randomUUID(),
        name: email,
      },
      { transaction: false },
    );
    await this.appleAuthRepository.save(
      {
        appleId: sub,
        user,
      },
      { transaction: false },
    );
    return this.createToken(user);
  }

  private async signin({ sub }: AppleIdentityTokenPayload) {
    const user = await this.appleAuthRepository
      .createQueryBuilder()
      .relation('user')
      .of(sub)
      .loadOne();
    return this.createToken(user);
  }

  @Transactional()
  private async delete({ sub }: AppleIdentityTokenPayload) {
    const user = await this.appleAuthRepository.findOneOrFail({
      where: { appleId: sub },
    });
    await this.userRepository.remove(user.user);
  }

  private createToken(user: Authentication) {
    return plainToInstance(AppleClientAuthResponse, {
      accessToken: this.jwtService.sign(instanceToPlain(user)),
    });
  }

  private extractJwtHeader(token: string): AppleIdentityTokenHeader {
    const [headerRaw] = token.split('.');
    const headerJson = Buffer.from(headerRaw, 'base64').toString();
    return plainToInstance(AppleIdentityTokenHeader, JSON.parse(headerJson));
  }
}
