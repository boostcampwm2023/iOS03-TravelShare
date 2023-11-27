import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsBoolean,
  IsDate,
  IsInt,
  IsPositive,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { UserProfileSimpleResponse } from 'user/user.profile.simple.response.dto';
import { RouteCoordinates } from '../route/route.coordinates.dto';
import { PostContentElementBase } from './post.content.element.base.dto';

export class PostDetailElement extends PostContentElementBase {}

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
  @ValidateNested()
  @Type(() => UserProfileSimpleResponse)
  writer: UserProfileSimpleResponse;

  @ApiProperty({
    description: '이동 경로, 2차원 배열입니다.',
    type: RouteCoordinates,
  })
  @ValidateNested()
  @Type(() => RouteCoordinates)
  route: RouteCoordinates;

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
