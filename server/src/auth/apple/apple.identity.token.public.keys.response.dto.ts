import { Type } from 'class-transformer';
import { IsArray, IsString, ValidateNested } from 'class-validator';

/**
 * GET https://appleid.apple.com/auth/keys
 */
export class AppleIdentityTokenPublicKeys {
  @IsArray()
  @ValidateNested()
  @Type(() => AppleIdentityTokenPublicKey)
  keys: AppleIdentityTokenPublicKey[];

  findMatchedKeyBy(alg: string, kid: string): AppleIdentityTokenPublicKey {
    return this.keys.find((key) => {
      return kid === key.kid;
    });
  }
}

/**
 * identityToken과 alg, kid를 비교해야합니다.
 */
export class AppleIdentityTokenPublicKey {
  @IsString()
  alg: string;

  @IsString()
  e: string;

  @IsString()
  kid: string;

  @IsString()
  kty: string;

  @IsString()
  n: string;

  @IsString()
  use: string;
}
