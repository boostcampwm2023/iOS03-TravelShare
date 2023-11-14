import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import {
  IsNumber,
  IsOptional,
  IsPhoneNumber,
  IsString,
  IsUrl,
} from 'class-validator';

export class MapSearchResponse {
  @ApiProperty({ description: '업체/기관 이름' })
  @IsString()
  title: string;

  @ApiProperty({ description: '링크' })
  @IsUrl()
  @IsOptional()
  link?: string;

  @ApiProperty({ description: '카테고리' })
  @IsString()
  category: string;

  @ApiProperty({ description: '설명' })
  @IsString()
  description: string;

  @ApiProperty({ description: '전화번호' })
  @IsPhoneNumber('KR')
  telephone: string;

  @ApiProperty({ description: '지번 주소' })
  @IsString()
  address: string;

  @ApiProperty({ description: '도로명 주소' })
  @IsString()
  roadAddress: string;

  @ApiProperty({ description: 'x좌표' })
  @IsNumber()
  @Transform((value) => parseFloat(value.value) / 10000000)
  mapx: number;

  @ApiProperty({ description: 'y좌표' })
  @IsNumber()
  @Transform((value) => parseFloat(value.value) / 10000000)
  mapy: number;
}
