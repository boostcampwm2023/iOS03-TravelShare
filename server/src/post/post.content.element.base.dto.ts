import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsNumber,
  IsOptional,
  IsString,
  IsUrl,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';
import { RouteCoordinate } from 'src/route/route.coordinates.dto';

class PostContentElementPoint extends RouteCoordinate {}

export class PostContentElementBase {
  @ApiProperty({
    description: '이미지 url',
    required: false,
    example: 'https://hereis.imageurl/optional',
  })
  @IsUrl()
  @IsOptional()
  imageUrl?: string;

  @ApiProperty({ description: '설명', example: '이곳에 설명이 들어갑니다.' })
  @IsString()
  description: string;

  @ApiProperty({ description: '좌표입니다.' })
  @ValidateNested()
  @Type(() => PostContentElementPoint)
  coordinate: PostContentElementPoint;
}
