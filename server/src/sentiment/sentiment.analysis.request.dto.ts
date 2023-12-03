import { Type } from 'class-transformer';
import { IsObject, IsString, IsUrl, ValidateNested } from 'class-validator';

class SentimentAnalysisRequestHeaders {
  [key: string]: any;

  @IsString()
  'X-NCP-APIGW-API-KEY-ID': string;

  @IsString()
  'X-NCP-APIGW-API-KEY': string;

  @IsString()
  'Content-Type': string = 'application/json';
}

export class SentimentAnalysisRequest {
  @IsString()
  method: string;

  @IsUrl()
  url: string;

  @IsObject()
  @ValidateNested()
  @Type(() => SentimentAnalysisRequestHeaders)
  headers: SentimentAnalysisRequestHeaders;
}
