import { IsIn, IsOptional, IsString } from 'class-validator';

export class AppleAuthRevokeBody {
  @IsString()
  client_id: string;

  @IsString()
  client_secret: string;

  @IsString()
  token: string;

  @IsIn(['refresh_token', 'access_token'])
  @IsOptional()
  token_type_hint: 'refresh_token' | 'access_token';

  toString(): string {
    return new URLSearchParams(this as any).toString();
  }
}
