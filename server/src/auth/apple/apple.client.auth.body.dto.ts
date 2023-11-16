import { ApiProperty } from '@nestjs/swagger';
import { IsJWT } from 'class-validator';

export class AppleClientAuthBody {
  @ApiProperty({ description: 'IdentityToken입니다.' })
  @IsJWT()
  identityToken: string;
}
