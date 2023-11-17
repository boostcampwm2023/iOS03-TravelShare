import { ApiProperty } from '@nestjs/swagger';
import { IsDate, IsJWT, IsOptional } from 'class-validator';

export class AppleClientAuthResponse {
  @ApiProperty({ description: 'access-token 애플 것이 아니라 우리 거' })
  @IsJWT()
  accessToken: string;

  @ApiProperty({ description: '만료' })
  @IsDate()
  @IsOptional()
  expiresIn?: Date;
}
