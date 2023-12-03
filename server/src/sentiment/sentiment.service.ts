import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AxiosResponse } from 'axios';
import { map } from 'rxjs';
import { plainToInstance } from 'class-transformer';
import { SentimentAnalysisResponse } from './sentiment.analysis.response.dto';

@Injectable()
export class SentimentService {
  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
  ) {}
  async SentimentAnalysis(content: string) {
    return this.httpService
      .post(this.configService.get('naver.sentiment.url'), {
        headers: this.configService.get('naver.sentiment.headers'),
        Body: {
          content: `${content}`,
        },
      })
      .pipe(
        map(({ data }: AxiosResponse) => {
          return plainToInstance(SentimentAnalysisResponse, data as any[]);
        }),
      );
  }
}
