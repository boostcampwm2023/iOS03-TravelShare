import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsNumber,
  IsNumberString,
  IsOptional,
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

  @ApiProperty({ description: '전화번호', required: false })
  @IsPhoneNumber('KR')
  @IsOptional()
  phoneNumber: string;

  @ApiProperty({ description: '카테고리' })
  @IsString()
  category: string;

  @ApiProperty({ description: '주소' })
  @IsString()
  address: string;

  @ApiProperty({ description: '도로명 주소', required: false })
  @IsString()
  @IsOptional()
  roadAddress: string;

  @ApiProperty({ description: '좌표' })
  @ValidateNested()
  @Type(() => RouteCoordinate)
  coordinate: RouteCoordinate;

  @ApiProperty({ description: '이 가게 다녀간 게시글 개수' })
  @Transform(({ value }) => parseInt(value))
  @IsNumber()
  postNum: number;
}
