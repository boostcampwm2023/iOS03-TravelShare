import { IsString } from 'class-validator';

export class AppleClientRefreshBody {
  @IsString()
  refreshToken: string;
}
