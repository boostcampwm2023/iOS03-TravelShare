import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { plainToInstance } from 'class-transformer';
import { KakaoMapSearchResponse } from './map.kakao.search.response.dto';
import { AxiosResponse } from 'axios';
import { map } from 'rxjs';

const pagenum = 1;
const sizenum = 15;

@Injectable()
export class KakaoMapService {
  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
  ) {}

  async kakaoSearchByAccuracy(keyword: string) {
    return this.httpService
      .get(
        this.configService.get('kakao.search.url') +
          encodeURI(
            `?page=${pagenum}&size=${sizenum}&sort=accuracy&query=${keyword}`,
          ),
        {
          headers: this.configService.get('kakao.search.headers'),
        },
      )
      .pipe(
        map(({ data }: AxiosResponse) => {
          return plainToInstance(
            KakaoMapSearchResponse,
            data?.documents as any[],
          );
        }),
      );
  }

  async kakaoSearchByDistance(keyword: string, x: number, y: number) {
    return this.httpService
      .get(
        this.configService.get('kakao.search.url') +
          encodeURI(
            `?page=${pagenum}&size=${sizenum}&sort=distance
          &query=${keyword}&x=${x}&y=${y}`,
          ),
        {
          headers: this.configService.get('kakao.search.headers'),
        },
      )
      .pipe(
        map(({ data }: AxiosResponse) => {
          return plainToInstance(
            KakaoMapSearchResponse,
            data?.documents as any[],
          );
        }),
      );
  }
}
