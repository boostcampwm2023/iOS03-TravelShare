import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AxiosResponse } from 'axios';
import { map } from 'rxjs';
import { plainToInstance } from 'class-transformer';
import { SentimentAnalysisResponse } from './sentiment.analysis.response.dto';
import { SentimentAnalysisBody } from './sentiment.analysis.body.dto';

@Injectable()
export class SentimentService {
  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
  ) {}
  async SentimentAnalysis({ content }: SentimentAnalysisBody) {
    return this.httpService
      .post(
        this.configService.get('naver.sentiment.url'),
        {
          content: `${content}`,
        },
        {
          headers: this.configService.get('naver.sentiment.headers'),
        },
      )
      .pipe(
        map(({ data }: AxiosResponse) => {
          return plainToInstance(SentimentAnalysisResponse, data as any[]);
        }),
      );
  }
}
