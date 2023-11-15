import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsDate,
  IsInt,
  IsNumber,
  IsObject,
  IsString,
  IsUrl,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { UserProfileSimpleResponse } from 'src/user/user.profile.simple.response.dto';

export class PostReadElement {
  @ApiProperty({ description: '이미지 url' })
  @IsUrl()
  imageUrl: string;

  @ApiProperty({ description: '내용' })
  @IsString()
  description: string;

  @ApiProperty({ description: 'x' })
  @IsNumber()
  positionX: number;

  @ApiProperty({ description: 'y좌표' })
  @IsNumber()
  positionY: number;

  @ApiProperty({ description: '장소 이름' })
  @IsString()
  locationName: string;

  @ApiProperty({ description: '주소' })
  locationAddress: string;
}

export class PostReadResponse {
  @ApiProperty({ description: '제목' })
  @IsString()
  title: string;

  @ApiProperty({ description: '내용들', type: [PostReadElement] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PostReadElement)
  elements: PostReadElement[];

  @ApiProperty({ description: '작성자' })
  @IsObject()
  user: UserProfileSimpleResponse;

  @ApiProperty({ description: '좋아요개수' })
  @IsInt()
  @Min(0)
  likeNum: number;

  @ApiProperty({ description: '조회수' })
  @IsInt()
  @Min(0)
  viewNum: number;

  @ApiProperty({ description: '생성' })
  @IsDate()
  createdAt: Date;

  @ApiProperty({ description: '수정' })
  @IsDate()
  modifiedAt: Date;
}
