import { Type } from 'class-transformer';
import { ValidateNested } from 'class-validator';
import { NcpEffectiveLogSearchAnalyticsRequest } from './ncp.elsa.request.dto';
import { NcpEffectiveLogSearchAnalyticsCredentials } from './ncp.elsa.credentials.dto';

export class NcpEffectiveLogSearchAnalyticsConfig {
  @ValidateNested()
  @Type(() => NcpEffectiveLogSearchAnalyticsRequest)
  request: NcpEffectiveLogSearchAnalyticsRequest;

  @ValidateNested()
  @Type(() => NcpEffectiveLogSearchAnalyticsCredentials)
  credentials: NcpEffectiveLogSearchAnalyticsCredentials;
}
