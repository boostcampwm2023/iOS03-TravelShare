import { Body, Controller, Put } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { RouteCoordinates } from './route.coordinates.dto';
import { RouteService } from './route.service';

@ApiTags('Route')
@Controller('route')
export class RouteController {
  constructor(private readonly routeService: RouteService) {}

  @ApiOperation({
    summary: '기록한 이동경로 배열을 업로드합니다.',
    description: `
# route/upload

- 지속적으로 기록한 이동경로를 기록합니다.
- 이후 routId를 통해 게시글 업로드에 이용할 수 있습니다.
        `,
  })
  @Put('upload')
  async upload(@Body() route: RouteCoordinates) {
    return await this.routeService.upload(route);
  }
}
