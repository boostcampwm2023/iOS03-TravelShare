import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AxiosResponse } from 'axios';
import { map } from 'rxjs';
import { MapSearchResponse } from './map.search.response.dto';
import { plainToInstance } from 'class-transformer';
const displayNum = 5;

@Injectable()
export class MapService {
  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
  ) {}

  async search(keyword: string) {
    return this.httpService
      .get(
        this.configService.get('naver.search.url') +
          encodeURI(`?query=${keyword}&display=${displayNum}`),
        {
          headers: this.configService.get('naver.search.headers'),
        },
      )
      .pipe(
        map(({ data }: AxiosResponse) => {
          return plainToInstance(MapSearchResponse, data?.items as any[]);
        }),
      );
  }
}
