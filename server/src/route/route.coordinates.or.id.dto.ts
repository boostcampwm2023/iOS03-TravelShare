import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, Validate, ValidateIf } from 'class-validator';
import { IsCoordinate } from './route.validator.constrant';
import { LineString } from 'src/entities/route.entity';

export class RouteCoordinatesOrId {
  @ApiProperty({
    description: '좌표 배열입니다.',
    example: [
      [36, 122.6],
      [35.6, 122.2],
    ],
    required: false,
  })
  @ValidateIf(({ routeId }: RouteCoordinatesOrId) => !Boolean(routeId))
  @Validate(IsCoordinate, { each: true })
  coordinates: LineString;

  @ApiProperty({
    description: '고유 id입니다.',
    example: 1,
    required: false,
  })
  @ValidateIf(({ coordinates }: RouteCoordinatesOrId) => !Boolean(coordinates))
  @IsNumber()
  routeId: number;
}
