import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsNumber,
  IsNumberString,
  IsPhoneNumber,
  IsString,
  ValidateNested,
} from 'class-validator';
import { RouteCoordinate } from 'route/route.coordinates.dto';

export class PostFindResponse {
  @ApiProperty({ description: '장소 id' })
  @IsNumberString()
  placeId: string;

  @ApiProperty({ description: '이름' })
  @IsString()
  placeName: string;

  @ApiProperty({ description: '전화번호' })
  @IsPhoneNumber('KR')
  phoneNumber: string;

  @ApiProperty({ description: '카테고리' })
  @IsString()
  category: string;

  @ApiProperty({ description: '주소' })
  @IsString()
  address: string;

  @ApiProperty({ description: '도로명 주소' })
  road_address: string;

  @ApiProperty({ description: '좌표' })
  @ValidateNested()
  @Type(() => RouteCoordinate)
  coordinate: RouteCoordinate;

  @ApiProperty({ description: '조회수' })
  @Transform(({ value }) => parseInt(value))
  @IsNumber()
  countPlace: number;
}
