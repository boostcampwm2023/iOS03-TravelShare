import { ApiProperty } from '@nestjs/swagger';
import {
  IsNumber,
  IsNumberString,
  IsOptional,
  IsPhoneNumber,
  IsString,
  IsUrl,
} from 'class-validator';

export class KakaoMapSearchResponse {
  @ApiProperty({ description: '업체/기관 이름' })
  @IsString()
  place_name: string;

  @ApiProperty({ description: '매장Id' })
  @IsNumberString()
  id: string;

  @ApiProperty({ description: '링크' })
  @IsUrl()
  @IsOptional()
  place_url?: string;

  @ApiProperty({ description: '카테고리 그룹' })
  @IsString()
  category_group_name: string;

  @ApiProperty({ description: '카테고리' })
  @IsString()
  category_name: string;

  @ApiProperty({ description: '전화번호' })
  @IsPhoneNumber('KR')
  @IsOptional()
  phone: string;

  @ApiProperty({ description: '지번 주소' })
  @IsString()
  address_name: string;

  @ApiProperty({ description: '도로명 주소' })
  @IsString()
  road_address_name: string;

  @ApiProperty({ description: 'x좌표' })
  @IsNumber()
  x: number;

  @ApiProperty({ description: 'y좌표' })
  @IsNumber()
  y: number;

  @ApiProperty({ description: '거리' })
  @IsNumber()
  @IsOptional()
  distance: number;
}
