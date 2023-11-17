import { ApiProperty } from '@nestjs/swagger';
import { IsJWT, IsNotEmpty } from 'class-validator';

export class UserSigninResponse {
  @ApiProperty({ description: 'jwt token' })
  @IsJWT()
  @IsNotEmpty()
  token: string;
}
