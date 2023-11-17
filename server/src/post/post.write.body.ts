import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsArray,
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
  imageUrl: string;

  @ApiProperty({ description: '설명' })
  @IsString()
  description: string;

  @ApiProperty({ description: 'x 좌표' })
  @IsNumber()
  mapx: number;

  @ApiProperty({ description: 'y 좌표' })
  @IsNumber()
  mapy: number;
}

export class PostWriteBody {
  @ApiProperty({ description: '게시글 아이디입니다. 업로드 이후에 리턴' })
  @IsInt()
  @IsOptional()
  id?: number;

  @ApiProperty({ description: '제목' })
  @IsString()
  title: string;

  @ApiProperty({ description: '사진과 글', type: [PostWriteElement] })
  @IsArray()
  @ValidateNested()
  @Type(() => PostWriteElement)
  contents: PostWriteElement[];
}
