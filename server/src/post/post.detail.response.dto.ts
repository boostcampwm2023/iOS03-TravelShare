import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsBoolean,
  IsDate,
  IsInt,
  IsNumber,
  IsString,
  IsUrl,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { UserProfileSimpleResponse } from 'src/user/user.profile.simple.response.dto';

export class PostDetailElement {
  @ApiProperty({ description: '이미지 url' })
  @IsUrl()
  imageUrl: string;

  @ApiProperty({ description: '내용' })
  @IsString()
  description: string;

  @ApiProperty({ description: 'x' })
  @IsNumber()
  x: number;

  @ApiProperty({ description: 'y좌표' })
  @IsNumber()
  y: number;
}

export class PostDetailResponse {
  @ApiProperty({ description: '제목' })
  @IsString()
  title: string;

  @ApiProperty({ description: '내용들', type: [PostDetailElement] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PostDetailElement)
  contents: PostDetailElement[];

  @ApiProperty({ description: '작성자' })
  @ValidateNested()
  @Type(() => UserProfileSimpleResponse)
  writer: UserProfileSimpleResponse;

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

  @ApiProperty({ description: '좋아요 여부' })
  @IsBoolean()
  liked: boolean;
}
