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

  @ApiOperation({
    summary: `검색어와의 유사성을 우선으로 결과를 나타냅니다`,
    description: `
  ## Map/v2/searchByAccuracy

  - 검색어에 대한 매장정보를 상세하게 알려줍니다.
  - 최대 45개까지 제공하고 있습니다.
  - 한 페이지 당 15개씩 제공하고 있습니다. pagenum 변수를 활용하세요.

    `,
  })
  @ApiResponse({ type: [KakaoMapSearchResponse] })
  @Public()
  @Get('searchByAccuracy')
  async searchByAccuracy(@Query() query: KakaoSearchAccuracyQuery) {
    return await this.kakaoMapService.kakaoSearchByAccuracy(query);
  }

  @ApiOperation({
    summary: '지정된 위치와 가까운 순으로 결과를 나타냅니다.',
    description: `
  ## Map/v2/searchByDistance

  - x에 경도, y에 위도 정보를 넣어줍니다.
  - distance 정보는 미터(m) 단위입니다.
  - 이외의 정보는 searchByAccuracy와 동일하게 제공됩니다.

    `,
  })
  @ApiResponse({ type: [KakaoMapSearchResponse] })
  @Public()
  @Get('searchByDistance')
  async searchByDistance(@Query() query: KakaoSearchDistanceQuery) {
    return await this.kakaoMapService.kakaoSearchByDistance(query);
  }
}
