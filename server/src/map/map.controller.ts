import { Controller, Get, Query } from '@nestjs/common';
import { ApiOperation, ApiResponse } from '@nestjs/swagger';
import { MapSearchResponse } from './map.search.response.dto';
import { MapService } from './map.service';
import { Public } from 'src/auth/auth.decorators';

@Controller('map')
export class MapController {
  constructor(private readonly mapService: MapService) {}

  @ApiOperation({ description: '주소나 이름에 따라 위치를 검색합니다.' })
  @ApiResponse({ type: [MapSearchResponse] })
  @Public()
  @Get('search')
  async search(@Query('keyword') keyword: string) {
    return await this.mapService.search(keyword);
  }
}
