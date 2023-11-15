import { Equals, IsInt, IsOptional, IsString } from 'class-validator';

export class AppleAuthTokenResponse {
  @IsString()
  access_token: string;

  @Equals('Bearer')
  token_type: string;

  @IsInt()
  expires_in: number;

  @IsString()
  @IsOptional()
  refresh_token?: string;

  @IsString()
  id_token: string;
}
