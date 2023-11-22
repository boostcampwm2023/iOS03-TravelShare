import { ApiProperty } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsArray,
  IsDate,
  IsInt,
  IsNumber,
  IsOptional,
  IsString,
  IsUrl,
  ValidateNested,
} from 'class-validator';

class PostWriteElement {
  @ApiProperty({ description: '이미지 url' })
  @IsUrl()
  @IsOptional()
  imageUrl?: string;

  @ApiProperty({ description: '설명' })
  @IsString()
  description: string;

  @ApiProperty({ description: 'x 좌표' })
  @IsNumber()
  x: number;

  @ApiProperty({ description: 'y 좌표' })
  @IsNumber()
  y: number;
}

export class PostWriteBody {
  @ApiProperty({ description: '게시글 아이디입니다. 업로드 이후에 리턴' })
  @IsInt()
  @IsOptional()
  id?: number;

  @ApiProperty({ description: '제목' })
  @IsString()
  title: string;

  @ApiProperty({ description: '요약', required: false })
  @IsString()
  @IsOptional()
  summary: string;

  @ApiProperty({ description: '이동좌표', type: [[Number, Number]] })
  @IsArray()
  route: [number, number][] = [];

  @ApiProperty({ description: '해시태그' })
  @IsArray()
  hashtag: string[] = [];

  @ApiProperty({ description: '사진과 글', type: [PostWriteElement] })
  @IsArray()
  @ValidateNested()
  @Type(() => PostWriteElement)
  contents: PostWriteElement[];

  @ApiProperty({ description: '시작 날짜', type: Date })
  @IsDate()
  @Transform(({ value }) => new Date(value))
  startAt: Date;

  @ApiProperty({ description: '종료 날짜', type: Date })
  @IsDate()
  @Transform(({ value }) => new Date(value))
  endAt: Date;
}
