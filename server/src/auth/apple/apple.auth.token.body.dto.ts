import { Equals, IsOptional, IsString, IsUrl } from 'class-validator';

export class AppleAuthTokenBody {
  @IsString()
  client_id: string;

  @IsString()
  client_secret: string;

  @IsString()
  @IsOptional()
  code?: string;

  @Equals('authorization_code')
  grant_type: string = 'authorization_code';

  @IsString()
  @IsOptional()
  refresh_token?: string;

  @IsUrl()
  @IsOptional()
  redirect_uri?: string;

  toString(): string {
    const query = { ...(this as any) };
    return new URLSearchParams(query).toString();
  }
}
