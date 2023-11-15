import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class AppleClientAuthResponse {
  @ApiProperty({ description: 'refresh' })
  @IsOptional()
  @IsString()
  refreshToken?: string;

  @ApiProperty({ description: 'access' })
  @IsString()
  accessToken: string;
}
