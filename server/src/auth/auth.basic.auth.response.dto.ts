import { ApiProperty } from '@nestjs/swagger';
import { IsJWT, IsNotEmpty } from 'class-validator';

export class AuthBasicAuthResponse {
  @ApiProperty({ description: '로그인 응답으로 제공되는 access token입니다.' })
  @IsJWT()
  @IsNotEmpty()
  accessToken: string;
}
