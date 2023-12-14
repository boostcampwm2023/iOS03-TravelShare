import { IsObject, ValidateNested } from 'class-validator';
import { SentimentAnalysisRequest } from './sentiment.analysis.request.dto';
import { Type } from 'class-transformer';

export class SentimentAnalysisConfig {
  @IsObject()
  @ValidateNested()
  @Type(() => SentimentAnalysisRequest)
  request: SentimentAnalysisRequest;
}
