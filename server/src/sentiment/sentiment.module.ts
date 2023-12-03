import { Module } from '@nestjs/common';
import { SentimentController } from './sentiment.controller';
import { SentimentService } from './sentiment.service';

@Module({
  controllers: [SentimentController],
  providers: [SentimentService],
})
export class SentimentModule {}
