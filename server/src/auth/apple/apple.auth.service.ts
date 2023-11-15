import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { AppleClientAuthBody } from './apple.client.auth.body.dto';
import { ConfigService } from '@nestjs/config';
import { map, mergeMap } from 'rxjs';
import { plainToInstance } from 'class-transformer';
import {
  AppleIdentityTokenPublicKey,
  AppleIdentityTokenPublicKeys,
} from './apple.identity.token.public.keys.response.dto';
import { AppleIdentityTokenPayload } from './apple.identity.token.payload.dto';
import { createPublicKey } from 'crypto';
import { AppleIdentityTokenHeader } from './apple.identity.token.header.dto';
import { AppleAuthTokenBody } from './apple.auth.token.body.dto';
import { AppleAuthTokenResponse } from './apple.auth.token.response.dto';

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
  ) {}

  async auth({ identityToken, authorizationCode }: AppleClientAuthBody) {
    const { tokenRequest, keysRequest } = this.configService.get('apple.auth');
    const { alg, kid } = this.extractJwtHeader(identityToken);
    // 사전에 clientsecret을 생성합니다.
    const clientSecret = this.jwtService.sign('');
    const clientId = this.configService.get('apple.client_id');
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
          type: 'pkcs8',
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
          this.jwtService.verify(identityToken, { publicKey }),
        );
      }),
      /**
       * 4. https://appleid.apple.com/auth/oauth2/v2/token로 요청을 보내 access token과 refresh token을 가져옵니다.
       */
      mergeMap(() => {
        const form = plainToInstance(AppleAuthTokenBody, {
          client_secret: clientSecret,
          client_id: clientId,
          code: authorizationCode,
        });
        return this.httpService.request({
          ...tokenRequest,
          data: form.toString(),
        });
      }),
      map(({ data }) => {
        return plainToInstance(AppleAuthTokenResponse, data);
      }),
    );
  }

  private extractJwtHeader(token: string): AppleIdentityTokenHeader {
    const [headerRaw] = token.split('.');
    const headerJson = Buffer.from(headerRaw, 'base64').toString();
    return plainToInstance(AppleIdentityTokenHeader, JSON.parse(headerJson));
  }
}
