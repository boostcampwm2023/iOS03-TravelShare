import { Global, Module } from '@nestjs/common';
import { SentimentController } from './sentiment.controller';
import { SentimentService } from './sentiment.service';

@Global()
@Module({
  controllers: [SentimentController],
  providers: [SentimentService],
})
export class SentimentModule {}
