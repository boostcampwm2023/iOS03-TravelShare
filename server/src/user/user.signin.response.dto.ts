import { ApiProperty } from '@nestjs/swagger';
import { IsJWT } from 'class-validator';

export class UserSigninResponse {
  @ApiProperty({ description: 'jwt token' })
  @IsJWT()
  token: string;
}
