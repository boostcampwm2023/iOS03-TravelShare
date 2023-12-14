import { Body, Controller, Put } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { RouteService } from './route.service';
import { RouteUploadResponse } from './route.upload.response.dto';
import { RouteUploadBody } from './route.upload.body.dto';

@ApiTags('Route')
@ApiBearerAuth('access-token')
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
  @ApiOkResponse({
    type: RouteUploadResponse,
  })
  @Put('upload')
  async upload(@Body() route: RouteUploadBody) {
    return await this.routeService.upload(route);
  }
}
