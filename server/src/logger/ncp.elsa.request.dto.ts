import { IsObject, IsString, IsUrl } from 'class-validator';

export class NcpEffectiveLogSearchAnalyticsRequest {
  @IsUrl()
  url: string;

  @IsObject()
  headers: Record<string, any> = {
    'Content-Type': 'application/json',
  };

  @IsString()
  method: string = 'POST';
}
