import { SentimentService } from './sentiment.service';
import { Get, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { RestController } from 'utils/rest.controller.decorator';
import { SentimentAnalysisResponse } from './sentiment.analysis.response.dto';
import { SentimentAnalysisQuery } from './sentiment.analysis.query.dto';

@ApiTags('Sentiment')
@RestController('sentiment')
export class SentimentController {
  constructor(private readonly sentimentService: SentimentService) {}

  @ApiOperation({
    summary: '문장의 감정을 분석합니다.',
    description: 'content 입력시 문장 별 감정을 분석해줍니다.',
  })
  @ApiResponse({ type: [SentimentAnalysisResponse] })
  @ApiBearerAuth('access-token')
  @Get('analysis')
  analysis(@Query() { content }: SentimentAnalysisQuery) {
    return this.sentimentService.analysis({ content });
  }
}
