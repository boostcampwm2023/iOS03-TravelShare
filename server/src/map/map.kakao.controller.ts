import { ApiOperation, ApiResponse } from '@nestjs/swagger';
import { KakaoMapSearchResponse } from './map.kakao.search.response.dto';
import { KakaoMapService } from './map.kakao.service';
import { Controller, Get, Query } from '@nestjs/common';
import { Public } from 'src/auth/auth.decorators';

@Controller('map/v2')
export class KaKaoMapController {
  constructor(private readonly kakaoMapService: KakaoMapService) {}

  @ApiOperation({ description: '주소나 이름에 따라 위치를 검색합니다.' })
  @ApiResponse({ type: [KakaoMapSearchResponse] })
  @Public()
  @Get('searchByAccuracy')
  async searchByAccuracy(@Query('keyword') keyword: string) {
    return await this.kakaoMapService.kakaoSearchByAccuracy(keyword);
  }

  @ApiOperation({ description: '주소나 이름에 따라 위치를 검색합니다.' })
  @ApiResponse({ type: [KakaoMapSearchResponse] })
  @Public()
  @Get('earchByDistance')
  async searchByDistance(
    @Query('keyword') keyword: string,
    @Query('x') x: number,
    @Query('y') y: number,
  ) {
    return await this.kakaoMapService.kakaoSearchByDistance(keyword, x, y);
  }
}
