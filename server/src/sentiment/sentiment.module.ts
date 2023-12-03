import { Module } from '@nestjs/common';
import { SentimentController } from './sentiment.controller';
import { SentimentService } from './sentiment.service';
import { ConfigManagerModule } from 'config/config.manager.module';
import { SentimentAnalysisConfig } from './sentiment.analysis.config.dto';

@Module({
  imports: [
    ConfigManagerModule.registerAs({
      schema: SentimentAnalysisConfig,
      path: 'naver.sentiment',
    }),
  ],
  controllers: [SentimentController],
  providers: [SentimentService],
})
export class SentimentModule {}
