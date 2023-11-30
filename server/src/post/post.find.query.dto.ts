import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsOptional, IsString } from 'class-validator';
import { PostPagination } from './post.pagination.dto';

export class PostFindQuery extends PostPagination {
  @ApiProperty({ description: '검색할 제목', required: false })
  @IsString()
  @IsOptional()
  title?: string;

  @ApiProperty({ description: '유저 이름', required: false })
  @IsString()
  @IsOptional()
  username?: string;

  @ApiProperty({ description: '유저 이메일', required: false })
  @IsEmail()
  @IsOptional()
  email: string;
}
