import { ApiProperty } from '@nestjs/swagger';
import {
  IsArray,
  IsBoolean,
  IsDateString,
  IsInt,
  IsObject,
  IsOptional,
  IsPositive,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';
import { Transform, Type } from 'class-transformer';
import { UserProfileSimpleResponse } from 'user/user.profile.simple.response.dto';
import { PostContentElementBase } from 'post/post.content.element.base.dto';
import { RouteCoordinates } from 'route/route.coordinates.dto';
import { PlaceBase } from 'post/place.base.dto';

export class PostDetailElement extends PostContentElementBase {}

export class PostDetailResponse {
  @ApiProperty({ description: '게시글 id' })
  @IsInt()
  @IsPositive()
  postId: number;

  @ApiProperty({ description: '제목' })
  @IsString()
  title: string;

  @ApiProperty({ description: '요약', required: false })
  @IsString()
  @IsOptional()
  summary: string;

  @ApiProperty({
    description: '내용들',
    type: [PostDetailElement],
    required: false,
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PostDetailElement)
  @IsOptional()
  contents: PostDetailElement[];

  @ApiProperty({ description: '작성자', type: UserProfileSimpleResponse })
  @IsObject()
  @ValidateNested()
  @Type(() => UserProfileSimpleResponse)
  writer: UserProfileSimpleResponse;

  @ApiProperty({
    description: '이동 경로, 2차원 배열입니다.',
    type: RouteCoordinates,
    required: false,
  })
  @IsObject()
  @ValidateNested()
  @Type(() => RouteCoordinates)
  @IsOptional()
  route: RouteCoordinates;

  @ApiProperty({ description: '핑 정보를 넣어줍니다.', type: [PlaceBase] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => PlaceBase)
  @IsOptional()
  pins: PlaceBase[];

  @ApiProperty({ description: '좋아요개수' })
  @IsInt()
  @Min(0)
  likeNum: number;

  @ApiProperty({ description: '조회수' })
  @IsInt()
  @Min(0)
  viewNum: number;

  @ApiProperty({ description: '생성' })
  @Transform(({ value }) =>
    value instanceof Date ? value.toISOString() : value,
  )
  @IsDateString()
  createdAt: Date;

  @ApiProperty({ description: '수정' })
  @Transform(({ value }) =>
    value instanceof Date ? value.toISOString() : value,
  )
  @IsDateString()
  modifiedAt: Date;

  @ApiProperty({ description: '좋아요 여부' })
  @IsBoolean()
  liked: boolean;
}
