import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { plainToInstance } from 'class-transformer';
import { KakaoMapSearchResponse } from './map.kakao.search.response.dto';
import { AxiosResponse } from 'axios';
import { map } from 'rxjs';
import { KakaoSearchAccuracyQuery } from './map.kakao.search.accuracy.query.dto';
import { KakaoSearchDistanceQuery } from './map.kakao.search.distance.query.dto';

const sizenum = 15;

@Injectable()
export class KakaoMapService {
  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
  ) {}

  async kakaoSearchByAccuracy({ keyword, pagenum }: KakaoSearchAccuracyQuery) {
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

  async kakaoSearchByDistance({
    keyword,
    pagenum,
    x,
    y,
  }: KakaoSearchDistanceQuery) {
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
