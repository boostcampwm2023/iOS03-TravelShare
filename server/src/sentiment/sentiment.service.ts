import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { AxiosResponse } from 'axios';
import { map } from 'rxjs';
import { plainToInstance } from 'class-transformer';
import { SentimentAnalysisResponse } from './sentiment.analysis.response.dto';
import { SentimentAnalysisQuery } from './sentiment.analysis.query.dto';
import { SentimentAnalysisConfig } from './sentiment.analysis.config.dto';
import { validateOrReject } from 'class-validator';

@Injectable()
export class SentimentService {
  constructor(
    private readonly httpService: HttpService,
    private readonly sentimentAnalysisConfig: SentimentAnalysisConfig,
  ) {}
  analysis(query: SentimentAnalysisQuery) {
    return this.httpService
      .request({
        ...this.sentimentAnalysisConfig.request,
        data: query,
      })
      .pipe(
        map(({ data }: AxiosResponse) => {
          return plainToInstance(SentimentAnalysisResponse, data);
        }),
      );
  }

  analysisWithValidation(query: SentimentAnalysisQuery) {
    return this.analysis(query).pipe(
      map(async (response) => {
        await validateOrReject(response);
        return response;
      }),
    );
  }
}
