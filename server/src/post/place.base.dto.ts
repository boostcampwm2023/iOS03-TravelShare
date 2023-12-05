import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsNumberString,
  IsOptional,
  IsPhoneNumber,
  IsString,
  ValidateNested,
} from 'class-validator';
import { RouteCoordinate } from 'route/route.coordinates.dto';

export class PlaceBase {
  @ApiProperty({ description: '장소 고유 id입니다.', example: '1234567' })
  @IsNumberString()
  placeId: string;

  @ApiProperty({ description: '장소 이름입니다.', example: '어디어디가게' })
  @IsString()
  placeName: string;

  @ApiProperty({
    description: '매장 번호입니다.',
    example: '01012345678',
    required: false,
  })
  @IsPhoneNumber('KR')
  @IsOptional()
  phoneNumber: string;

  @ApiProperty({
    description: '매장 카테고리입니다.',
    example: '무엇 > 무엇 > 무엇',
  })
  @IsString()
  category: string;

  @ApiProperty({ description: '장소 주소', example: '어디동 ' })
  @IsString()
  address: string;

  @ApiProperty({
    description: '도로명 주소입니다.',
    example: '어디길',
    required: false,
  })
  @IsString()
  @IsOptional()
  roadAddress: string;

  @ApiProperty({ description: '핑 좌표' })
  @ValidateNested()
  @Type(() => RouteCoordinate)
  coordinate: RouteCoordinate;
}
