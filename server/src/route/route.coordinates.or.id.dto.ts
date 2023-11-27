import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, Validate, ValidateIf, ValidateNested } from 'class-validator';
import { LineString } from 'src/entities/route.entity';
import { RouteCoordinate, RouteCoordinates } from './route.coordinates.dto';
import { Type } from 'class-transformer';

export class RouteCoordinatesOrId {
  @ApiProperty({
    description: '좌표 배열입니다.',
    example: [
      {
        x: 120,
        y: 33.6
      },
      {
        x: 127.86,
        y: 35.8
      }
    ],
    required: false,
  })
  @ValidateIf(({ routeId }: RouteCoordinatesOrId) => !Boolean(routeId))
  @ValidateNested()
  @Type(()=> RouteCoordinate)
  coordinates: RouteCoordinate[];

  @ApiProperty({
    description: '고유 id입니다.',
    example: 1,
    required: false,
  })
  @ValidateIf(({ coordinates }: RouteCoordinatesOrId) => !Boolean(coordinates))
  @IsNumber()
  routeId: number;
}
