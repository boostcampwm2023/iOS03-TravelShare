import {
  IsArray,
  IsNotEmpty,
  IsNumber,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class RouteCoordinates {
  @ApiProperty({
    description:
      '좌표 배열입니다. [latitude(y), logitude(x)]의 순서로 좌표 쌍을 만들어주세요.',
    example: [
      {
        x: 120,
        y: 33.6,
      },
      {
        x: 127.86,
        y: 35.8,
      },
    ],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => RouteCoordinate)
  coordinates: RouteCoordinate[];
}

export class RouteCoordinate {
  @ApiProperty({ description: 'x ' })
  @IsNumber()
  @Max(180)
  @Min(-180)
  @IsNotEmpty()
  x: number;

  @ApiProperty({ description: 'y' })
  @IsNumber()
  @Max(90)
  @Min(-90)
  @IsNotEmpty()
  y: number;
}
