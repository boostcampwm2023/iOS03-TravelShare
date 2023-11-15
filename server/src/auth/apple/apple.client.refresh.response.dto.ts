import { IsString } from 'class-validator';

export class AppleClientRefreshResponse {
  @IsString()
  accessToken: string;
}
