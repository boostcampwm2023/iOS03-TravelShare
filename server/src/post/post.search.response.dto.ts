import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsInt,
  IsObject,
  IsOptional,
  IsString,
  IsUrl,
  Min,
  ValidateNested,
} from 'class-validator';
import { UserProfileSimpleResponse } from 'user/user.profile.simple.response.dto';

export class PostSearchResponse {
  @ApiProperty({ description: '게시글 id' })
  @IsInt()
  @Min(0)
  postId: number;

  @ApiProperty({ description: '게시글 타이틀' })
  @IsString()
  title: string;

  @ApiProperty({ description: '게시글 요약' })
  @IsString()
  summary: string;

  @ApiProperty({ description: '이미지 url' })
  @IsUrl()
  @IsOptional()
  imageUrl?: string;

  @ApiProperty({ description: '좋아요 개수' })
  @Min(0)
  @IsInt()
  likeNum: number;

  @ApiProperty({ description: '조회수' })
  @Min(0)
  @IsInt()
  viewNum: number;

  @ApiProperty({ description: '작성자 정보입니다.' })
  @IsObject()
  @ValidateNested()
  @Type(() => UserProfileSimpleResponse)
  writer: UserProfileSimpleResponse;

  @ApiProperty({ description: '좋아요 여부(내가 좋아요 눌렀었나?)' })
  @IsBoolean()
  @IsOptional()
  liked: boolean;
}
