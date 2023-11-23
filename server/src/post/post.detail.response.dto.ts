import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsBoolean,
  IsDate,
  IsInt,
  IsNumber,
  IsOptional,
  IsPositive,
  IsString,
  IsUrl,
  Min,
  Validate,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { UserProfileSimpleResponse } from 'src/user/user.profile.simple.response.dto';
import { IsRouteArray } from './post.route.validator';

export class PostDetailElement {
  @ApiProperty({ description: '이미지 url', required: false })
  @IsUrl()
  @IsOptional()
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
  @ApiProperty({ description: '게시글 id' })
  @IsInt()
  @IsPositive()
  postId: number;

  @ApiProperty({ description: '제목' })
  @IsString()
  title: string;

  @ApiProperty({ description: '내용들', type: [PostDetailElement] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PostDetailElement)
  contents: PostDetailElement[];

  @ApiProperty({ description: '작성자' })
  @Type(() => UserProfileSimpleResponse)
  writer: UserProfileSimpleResponse;

  @ApiProperty({ description: '이동 경로, 2차원 배열입니다.', type: [[0, 0]] })
  @Validate(IsRouteArray, { each: true })
  route: [number, number][];

  @ApiProperty({ description: '해시태그' })
  @IsArray()
  hashtag: string[];

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
