import { Validate } from 'class-validator';
import { IsCoordinate } from './route.validator.constrant';
import { ApiProperty } from '@nestjs/swagger';

export class RouteCoordinates {
  @ApiProperty({
    description:
      '좌표 배열입니다. [latitude(y), logitude(x)]의 순서로 좌표 쌍을 만들어주세요.',
    example: [
      [36, 122.6],
      [35.6, 122.2],
    ],
  })
  @Validate(IsCoordinate, { each: true })
  coordinates: [number, number][];
}
