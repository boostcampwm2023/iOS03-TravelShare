import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsOptional, IsString, IsUrl, ValidateNested } from 'class-validator';
import { RouteCoordinate } from 'route/route.coordinates.dto';

class PostContentElementPoint extends RouteCoordinate {}

export class PostContentElementBase {
  @ApiProperty({
    description: '이미지 url',
    example:
      'https://kr.object.ncloudstorage.com/macro-bucket/static/image/boostcampmacro-beeae45f-3772-427c-ab71-bf85b663b043',
  })
  @IsUrl()
  imageUrl: string;

  @ApiProperty({
    description: '설명',
    example: '이곳에 설명이 들어갑니다.',
    required: false,
  })
  @IsString()
  @IsOptional()
  description: string;

  @ApiProperty({ description: '좌표입니다.', required: false })
  @ValidateNested()
  @Type(() => PostContentElementPoint)
  @IsOptional()
  coordinate: PostContentElementPoint;
}
