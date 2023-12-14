import { ApiProperty } from '@nestjs/swagger';
import { IsJWT, IsString } from 'class-validator';

export class AppleClientRevokeBody {
  @ApiProperty({ description: 'IdentityToken입니다.' })
  @IsJWT()
  identityToken: string;

  @ApiProperty({ description: 'Authorization Code' })
  @IsString()
  authorizationCode: string;
}
