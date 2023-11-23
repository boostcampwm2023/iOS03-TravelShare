import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString, IsUrl } from 'class-validator';

export class UserProfileUpdateQuery {
  @ApiProperty({ description: '이름' })
  @IsString()
  name?: string;

  @ApiProperty({ description: '이미지 url', required: false })
  @IsUrl()
  @IsOptional()
  imageUrl?: string;

  @ApiProperty({ description: '소개', required: false })
  @IsString()
  @IsOptional()
  introduce?: string;
}
