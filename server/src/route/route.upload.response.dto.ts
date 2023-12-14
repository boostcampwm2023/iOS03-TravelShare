import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, Min } from 'class-validator';

export class RouteUploadResponse {
  @ApiProperty({ description: '경로 고유 id입니다.' })
  @IsNumber()
  @Min(0)
  routeId: number;
}
