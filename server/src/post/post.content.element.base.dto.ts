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

class PostContentElementPoint {
  @ApiProperty({ description: 'x 좌표', example: 128.0 })
  @IsNumber()
  @Min(124.5)
  @Max(132.0)
  x: number;

  @ApiProperty({ description: 'y 좌표', example: 35.6 })
  @IsNumber()
  @Min(33.0)
  @Max(38.9)
  y: number;
}

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
