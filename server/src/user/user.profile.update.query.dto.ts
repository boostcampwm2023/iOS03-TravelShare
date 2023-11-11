import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsUrl } from 'class-validator';

export class UserProfileUpdateQuery {
  @ApiProperty({ description: '이름' })
  @IsString()
  name?: string;

  @ApiProperty({ description: '이미지 url' })
  @IsUrl()
  imageUrl?: string;

  @ApiProperty({ description: '소개' })
  @IsString()
  introduce?: string;
}
