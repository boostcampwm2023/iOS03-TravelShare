import { ApiProperty } from '@nestjs/swagger';
import { Expose, Transform } from 'class-transformer';
import { IsEmail, IsIn, IsOptional, IsString } from 'class-validator';

export class PostFindQuery {
  @ApiProperty({ description: '검색어' })
  @IsString()
  @IsOptional()
  keyword?: string;

  @ApiProperty({ description: '유저 아이디' })
  @IsEmail()
  @IsOptional()
  @Expose({ name: 'user_id' })
  userId?: string;

  @ApiProperty({ description: '쓴 글', enum: ['writed', 'liked'] })
  @IsIn(['writed', 'liked'])
  @IsOptional()
  @Transform(({ value }) => value.toLowerCase())
  mode?: string;
}
