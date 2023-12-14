import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNumberString, IsOptional, IsString } from 'class-validator';
import { PostPagination } from './post.pagination.dto';

export class PostSearchQuery extends PostPagination {
  @ApiProperty({ description: '검색할 제목', required: false })
  @IsString()
  @IsOptional()
  title?: string;

  @ApiProperty({ description: '검색할 내용', required: false })
  @IsString()
  @IsOptional()
  content?: string;

  @ApiProperty({ description: '검색할 키워드(제목 + 내용)', required: false })
  @IsString()
  @IsOptional()
  keyword?: string;

  @ApiProperty({ description: '유저 이름', required: false })
  @IsString()
  @IsOptional()
  username?: string;

  @ApiProperty({ description: '유저 이메일', required: false })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiProperty({ description: '', required: false })
  @IsNumberString()
  @IsOptional()
  placeId?: string;
}
