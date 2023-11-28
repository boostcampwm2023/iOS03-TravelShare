import { ApiProperty } from '@nestjs/swagger';
import { IsEmail } from 'class-validator';

export class UserFollowQuery {
  @ApiProperty({ description: '팔로잉 누를 사람' })
  @IsEmail()
  followee: string;
}
