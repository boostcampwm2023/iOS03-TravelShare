import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { KakaoMapSearchResponse } from './map.kakao.search.response.dto';
import { KakaoMapService } from './map.kakao.service';
import { Controller, Get, Query } from '@nestjs/common';
import { Public } from 'auth/auth.decorators';
import { KakaoSearchAccuracyQuery } from './map.kakao.search.accuracy.query.dto';
import { KakaoSearchDistanceQuery } from './map.kakao.search.distance.query.dto';

@ApiTags('Map/v2')
@Controller('map/v2')
export class KaKaoMapController {
  constructor(private readonly kakaoMapService: KakaoMapService) {}

  @ApiOperation({ description: '주소나 이름에 따라 위치를 검색합니다.' })
  @ApiResponse({ type: [KakaoMapSearchResponse] })
  @Public()
  @Get('searchByAccuracy')
  async searchByAccuracy(@Query() query: KakaoSearchAccuracyQuery) {
    return await this.kakaoMapService.kakaoSearchByAccuracy(query);
  }

  @ApiOperation({ description: '주소나 이름에 따라 위치를 검색합니다.' })
  @ApiResponse({ type: [KakaoMapSearchResponse] })
  @Public()
  @Get('searchByDistance')
  async searchByDistance(@Query() query: KakaoSearchDistanceQuery) {
    return await this.kakaoMapService.kakaoSearchByDistance(query);
  }
}
