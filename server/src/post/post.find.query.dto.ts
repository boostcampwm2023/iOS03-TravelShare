import { ApiProperty, OmitType } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import {
  IsEmail,
  IsIn,
  IsOptional,
  IsPositive,
  IsString,
  Max,
} from 'class-validator';

export class PostFindQuery {
  @ApiProperty({ description: '검색어' })
  @IsString()
  @IsOptional()
  keyword?: string;

  @ApiProperty({ description: '유저 아이디' })
  @IsEmail()
  @IsOptional()
  email?: string;

  @ApiProperty({ description: '쓴 글', enum: ['writed', 'liked'] })
  @IsIn(['writed', 'liked'])
  @IsOptional()
  @Transform(({ value }) => value.toLowerCase())
  mode?: 'writed' | 'liked';

  @ApiProperty({ description: '몇 개까지? 최대 10개' })
  @Max(10)
  @IsPositive()
  @IsOptional()
  take?: number = 10;

  @ApiProperty({ description: 'offset' })
  @IsPositive()
  @IsOptional()
  skip?: number = 10;
}

export class PostSearchKeywordQuery extends OmitType(PostFindQuery, [
  'email',
  'mode',
]) {}

export class PostFindOtherUserLogQuery extends OmitType(PostFindQuery, [
  'keyword',
]) {}

export class PostFindMyLogQuery extends OmitType(PostFindQuery, [
  'email',
  'keyword',
]) {}
