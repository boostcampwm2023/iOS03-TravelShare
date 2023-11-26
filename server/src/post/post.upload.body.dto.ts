import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsArray,
  IsBoolean,
  IsDate,
  IsNumber,
  IsOptional,
  IsString,
  IsUrl,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';
import { RouteCoordinatesOrId } from 'src/route/route.coordinates.or.id.dto';

class PostUploadElement {
  @ApiProperty({
    description: '이미지 url',
    required: false,
    example: 'https://hereis.imageurl/optional',
  })
  @IsUrl()
  @IsOptional()
  imageUrl?: string;

  @ApiProperty({ description: '설명', example: '이곳에 설명이 들어갑니다.' })
  @IsString()
  description: string;

  @ApiProperty({ description: 'x 좌표', example: 128.0 })
  @IsNumber()
  @Min(124.5)
  @Max(132.0)
  x: number;

  @ApiProperty({ description: 'y 좌표', example: 35.6 })
  @IsNumber()
  @Min(33.0)
  @Max(38.9)
  y: number;
}

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
    type: RouteCoordinatesOrId,
    examples: [
      {
        coordinates: [
          [126, 36],
          [126.2, 33.5],
        ],
      },
      { routeId: 1 },
    ],
  })
  @ValidateNested()
  @Type(() => RouteCoordinatesOrId)
  route: RouteCoordinatesOrId;

  @ApiProperty({
    description:
      '경로 고유 id입니다. 미리 경로를 업로드했을 경우 사용할 수 있습니다.',
  })
  @ApiProperty({ description: '해시태그' })
  @IsArray()
  hashtag: string[] = [];

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
