import { SentimentService } from './sentiment.service';
import { Body, Post } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { RestController } from 'utils/rest.controller.decorator';
import { SentimentAnalysisResponse } from './sentiment.analysis.response.dto';
import { SentimentAnalysisBody } from './sentiment.analysis.body.dto';

@ApiTags('Sentiment')
@RestController('sentiment')
export class SentimentController {
  constructor(private readonly sentimentService: SentimentService) {}

  @ApiOperation({
    summary: '문장의 감정을 분석합니다.',
    description: 'content 입력시 문장 별 감정을 분석해줍니다.',
  })
  @ApiResponse({ type: [SentimentAnalysisResponse] })
  @ApiBody({ type: SentimentAnalysisBody })
  @ApiBearerAuth('access-token')
  @Post('sentiment')
  async sentiment(@Body() { content }: SentimentAnalysisBody) {
    return await this.sentimentService.SentimentAnalysis({ content });
  }
}
