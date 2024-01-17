import { IsBoolean, IsOptional } from 'class-validator';
import { AuthBasicAuthResponse } from '../auth.basic.auth.response.dto';

export class AppleClientAuthResponse extends AuthBasicAuthResponse {
  @IsOptional()
  @IsBoolean()
  isSignup: boolean;
}
