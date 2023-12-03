import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { AxiosResponse } from 'axios';
import { map } from 'rxjs';
import { plainToInstance } from 'class-transformer';
import { SentimentAnalysisResponse } from './sentiment.analysis.response.dto';
import { SentimentAnalysisQuery } from './sentiment.analysis.query.dto';
import { SentimentAnalysisConfig } from './sentiment.analysis.config.dto';

@Injectable()
export class SentimentService {
  constructor(
    private readonly httpService: HttpService,
    private readonly sentimentAnalysisConfig: SentimentAnalysisConfig,
  ) {}
  async SentimentAnalysis(query: SentimentAnalysisQuery) {
    return this.httpService
      .request({
        ...this.sentimentAnalysisConfig.request,
        data: query,
      })
      .pipe(
        map(({ data }: AxiosResponse) => {
          return plainToInstance(SentimentAnalysisResponse, data as any[]);
        }),
      );
  }
}
