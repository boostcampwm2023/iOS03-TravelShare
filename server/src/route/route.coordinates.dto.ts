import { Validate } from 'class-validator';
import { IsCoordinate } from './route.validator.constrant';
import { ApiProperty } from '@nestjs/swagger';

export class RouteCoordinates {
  @ApiProperty({
    description: '좌표 배열입니다.',
    example: [
      [126, 36],
      [126.7, 35.6],
    ],
  })
  @Validate(IsCoordinate, { each: true })
  coordinates: [number, number][];
}
