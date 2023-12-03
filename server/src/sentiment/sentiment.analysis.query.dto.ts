import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class SentimentAnalysisQuery {
  @ApiProperty({ description: '분석할 문장입니다' })
  @IsString()
  content: string;
}
