import { IsIn, IsOptional, IsString } from 'class-validator';

export class NcpEffectiveLogSearchAnalyticsLogPayload {
  @IsString()
  body: string;

  @IsString()
  @IsIn(['log', 'fatal', 'error', 'warn', 'debug', 'verbose'])
  logLevel: 'log' | 'fatal' | 'error' | 'warn' | 'debug' | 'verbose';

  @IsString()
  logSource: string;

  @IsString()
  @IsOptional()
  logType?: string;
}
