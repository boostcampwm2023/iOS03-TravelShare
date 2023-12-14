import { IsString } from 'class-validator';

export class NcpEffectiveLogSearchAnalyticsCredentials {
  @IsString()
  projectName: string;

  @IsString()
  projectVersion: string;
}
