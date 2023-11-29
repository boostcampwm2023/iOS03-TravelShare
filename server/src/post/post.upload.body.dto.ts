import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsArray,
  IsBoolean,
  IsDate,
  IsOptional,
  IsString,
  ValidateNested,
} from 'class-validator';
import { PostContentElementBase } from './post.content.element.base.dto';
import { RouteCoordinates } from 'route/route.coordinates.dto';
import { PlaceBase } from './place.base.dto';

class PostUploadElement extends PostContentElementBase {}

export class PostUploadBody {
  @ApiProperty({
    description: '제목',
    example: '이곳에 게시글 제목이 들어갑니다. 필수.',
  })
  @IsString()
  title: string;

  @ApiProperty({
    description: '요약',
    required: false,
    example: '게시글 요약 문구입니다. 생략 가능',
  })
  @IsString()
  @IsOptional()
  summary: string;

  @ApiProperty({
    description:
      '경로 좌표입니다. 고유 id 혹은 경로 좌표 배열 중 하나가 포함되어야 합니다.',
    type: RouteCoordinates,
    examples: [
      {
        coordinates: [
          {
            x: 122,
            y: 33,
          },
          {
            x: 123.123,
            y: 33.123,
          },
        ],
      },
    ],
  })
  @ValidateNested()
  @Type(() => RouteCoordinates)
  route: RouteCoordinates;

  @ApiProperty({ description: '핑 정보를 넣어줍니다.', type: [PlaceBase] })
  @ValidateNested({ each: true })
  @Type(() => PlaceBase)
  pings: PlaceBase[];

  @ApiProperty({ description: '사진과 글', type: [PostUploadElement] })
  @IsArray()
  @ValidateNested()
  @Type(() => PostUploadElement)
  contents: PostUploadElement[];

  @ApiProperty({
    description: '게시글 공개 여부',
    required: false,
    default: true,
  })
  @IsBoolean()
  @IsOptional()
  public: boolean = true;

  @ApiProperty({ description: '시작 날짜', type: Date })
  @IsDate()
  @Transform(({ value }) => new Date(value))
  startAt: Date;

  @ApiProperty({ description: '종료 날짜', type: Date })
  @IsDate()
  @Transform(({ value }) => new Date(value))
  endAt: Date;
}
