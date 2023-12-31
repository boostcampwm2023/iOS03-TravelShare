import { ApiProperty } from '@nestjs/swagger';
import {
  IsBoolean,
  IsEmail,
  IsInt,
  IsOptional,
  IsString,
  IsUrl,
  Min,
} from 'class-validator';

export class UserProfileResponse {
  @ApiProperty({ description: '작성자 email' })
  @IsEmail()
  email: string;

  @ApiProperty({ description: '작성자 이름' })
  @IsString()
  name: string;

  @ApiProperty({ description: '프로필 사진 url', required: false })
  @IsUrl()
  @IsOptional()
  imageUrl?: string;

  @ApiProperty({ description: '자기소개', required: false })
  @IsString()
  @IsOptional()
  introduce?: string;

  @ApiProperty({
    description:
      '내가 이 사람을 팔로우하고 있나? 자기 자신을 열람할 땐 조회되지 않습니다.',
    required: false,
  })
  @IsBoolean()
  @IsOptional()
  followee?: boolean;

  @ApiProperty({ description: '이 사람이 나를 팔로우하나?', required: false })
  @IsBoolean()
  @IsOptional()
  follower?: boolean;

  @ApiProperty({ description: '' })
  @ApiProperty({ description: '팔로워 수' })
  @IsInt()
  @Min(0)
  followersNum: number;

  @ApiProperty({ description: '팔로잉 수' })
  @IsInt()
  @Min(0)
  followeesNum: number;
}
