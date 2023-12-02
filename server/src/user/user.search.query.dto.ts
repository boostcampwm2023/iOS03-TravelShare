import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsOptional, IsString } from 'class-validator';
import { UserPagination } from './user.pagination.dto';

export class UserSearchQuery extends UserPagination {
  @ApiProperty({ description: '검색할 이메일', required: false })
  @IsEmail()
  @IsOptional()
  email: string;

  @ApiProperty({ description: '검색할 이름(닉네임)', required: false })
  @IsString()
  @IsOptional()
  name: string;
}
