import { HttpService } from '@nestjs/axios';
import {
  ConflictException,
  Injectable,
  InternalServerErrorException,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { AppleClientAuthBody } from './apple.client.auth.body.dto';
import { ConfigService } from '@nestjs/config';
import { catchError, identity, map, mergeMap, throwError } from 'rxjs';
import { plainToInstance } from 'class-transformer';
import {
  AppleIdentityTokenPublicKey,
  AppleIdentityTokenPublicKeys,
} from './apple.identity.token.public.keys.response.dto';
import { AppleIdentityTokenPayload } from './apple.identity.token.payload.dto';
import { createPublicKey, randomInt, randomUUID } from 'crypto';
import { AppleIdentityTokenHeader } from './apple.identity.token.header.dto';
import { Repository } from 'typeorm';
import { AppleAuth } from 'entities/apple.auth.entity';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'entities/user.entity';
import { Authentication } from '../authentication.dto';
import { AppleClientRevokeBody } from './apple.client.revoke.body.dto';
import { AppleAuthTokenBody } from './apple.auth.token.body.dto';
import { AppleAuthRevokeBody } from './apple.auth.revoke.body.dto';
import { AppleAuthTokenResponse } from './apple.auth.token.response.dto';
import { AppleClientAuthResponse } from './apple.client.auth.response.dto';
import { Transactional } from 'typeorm-transactional';
import { getRandomNickName } from 'utils/namemaker';
import { AppleClientRevokeResponse } from './apple.client.revoke.response';
import { UserBlackListManager } from 'auth/blacklist/user.blacklist.manager';

/**
 * ### AppleAuthService
 * - 애플 OAuth2 로그인(모바일 기기의 플로우만 고려했습니다.)을 구현합니다.
 * - 아직 테스트가 필요합니다.
 * @author NOSSOH, JIJIHUNY
 */
@Injectable()
export class AppleAuthService {
  private readonly logger: Logger = new Logger(AppleAuthService.name);
  constructor(
    private readonly httpService: HttpService,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    @InjectRepository(AppleAuth)
    private readonly appleAuthRepository: Repository<AppleAuth>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly userBlackListManager: UserBlackListManager,
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
      keys: keysRequest,
      revoke: revokeRequest,
    } = this.configService.get('apple.auth');
    const { alg, kid } = this.extractJwtHeader(identityToken);
    const { payload, header, secret } = this.configService.get(
      'apple.client_secret',
    );
    const clientSecret = this.jwtService.sign(payload, { header, secret });
    return this.httpService.request(keysRequest).pipe(
      catchError((err) => {
        this.logger.error(err);
        return throwError(
          () =>
            new InternalServerErrorException('apple revoking error on /keys', {
              cause: err,
            }),
        );
      }),
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
          client_id: payload.sub,
          code: authorizationCode,
        }).toString();
      }),
      mergeMap((data) => {
        return this.httpService.request({ ...tokenRequest, data }).pipe(
          catchError((err) => {
            this.logger.error(JSON.stringify(err));
            return throwError(
              () =>
                new InternalServerErrorException(
                  'apple revoking error on /token',
                  { cause: err },
                ),
            );
          }),
          identity,
        );
      }),
      map(({ data }) => {
        return plainToInstance(AppleAuthTokenResponse, data).refresh_token;
      }),
      map((refreshToken) => {
        return plainToInstance(AppleAuthRevokeBody, {
          client_id: payload.sub,
          client_secret: clientSecret,
          token: refreshToken,
          token_type_hint: 'refresh_token',
        }).toString();
      }),
      mergeMap((tokenBody) => {
        return this.httpService
          .request({ ...revokeRequest, data: tokenBody })
          .pipe(
            catchError((err) => {
              this.logger.error(JSON.stringify(err));
              return throwError(
                () =>
                  new InternalServerErrorException(
                    'apple request error on /revoke',
                    { cause: err },
                  ),
              );
            }),
            identity,
          );
      }),
      map(() => plainToInstance(AppleClientRevokeResponse, {})),
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
    const user = await this.userRepository
      .save(
        {
          email: email ?? `${randomInt(10 ** 10, 10 ** 11)}@macrogenerated.com`,
          password: randomUUID(),
          name: getRandomNickName(),
        },
        { transaction: false },
      )
      .catch((err) => {
        this.logger.error(err);
        throw new ConflictException('duplicate user', { cause: err });
      });
    await this.appleAuthRepository
      .save(
        {
          appleId: sub,
          user,
        },
        { transaction: false },
      )
      .catch((err) => {
        this.logger.error(err);
        throw new ConflictException('duplicate apple id', { cause: err });
      });
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
    try {
      const { user } = await this.appleAuthRepository.findOneOrFail({
        where: { appleId: sub },
        relations: {
          user: true,
        },
      });
      const userDetail = await this.userRepository.findOneBy({
        email: user.email,
      });
      await this.userRepository.remove(userDetail);
      await this.userBlackListManager.addRevokedBlacklist(user.email);
    } catch (err) {
      this.logger.error(err);
      throw new NotFoundException('user not found', { cause: err });
    }
    // TODO: soft delete
    // await this.userRepository.softDelete(user);
    // await this.postRepository.softDelete({
    //   postId: In(user.writedPosts.map(({ postId }) => postId)),
    // });
  }

  private createToken(user: Authentication) {
    return plainToInstance(AppleClientAuthResponse, {
      accessToken: this.jwtService.sign({ email: user.email, role: user.role }),
    });
  }

  private extractJwtHeader(token: string): AppleIdentityTokenHeader {
    const [headerRaw] = token.split('.');
    const headerJson = Buffer.from(headerRaw, 'base64').toString();
    return plainToInstance(AppleIdentityTokenHeader, JSON.parse(headerJson));
  }
}
