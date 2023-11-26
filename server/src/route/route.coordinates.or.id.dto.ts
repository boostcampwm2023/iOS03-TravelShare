import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsOptional, Validate } from 'class-validator';
import { IsCoordinate } from './route.validator.constrant';

export class RouteCoordinatesOrId {
  @ApiProperty({
    description: '좌표 배열입니다.',
    example: [
      [36, 122.6],
      [35.6, 122.2],
    ],
    required: false,
  })
  @Validate(IsCoordinate, { each: true })
  @IsOptional()
  coordinates: [number, number][];

  @ApiProperty({
    description: '고유 id입니다.',
    example: 1,
    required: false,
  })
  @IsNumber()
  @IsOptional()
  routeId: number;
}
