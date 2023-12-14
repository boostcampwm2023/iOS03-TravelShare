import { Get, Query } from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { MapSearchResponse } from './map.search.response.dto';
import { MapService } from './map.service';
import { RestController } from 'utils/rest.controller.decorator';

@ApiTags('Map/v1')
@RestController('map')
export class MapController {
  constructor(private readonly mapService: MapService) {}

  @ApiOperation({
    summary: '네이버 지도 api를 통해 위치정보를 받습니다.',
    description: `
- keyword 입력 시 5개의 위치 검색 결과값을 받습니다.
- 현재 기능이 좋지 않아 권장하지 않습니다.
  `,
  })
  @ApiResponse({ type: [MapSearchResponse] })
  @Get('search')
  async search(@Query('keyword') keyword: string) {
    return await this.mapService.search(keyword);
  }
}
