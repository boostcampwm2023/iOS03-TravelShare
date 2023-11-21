import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsOptional } from 'class-validator';

export class UserProfileQuery {
  @ApiProperty({ description: '이메일(아이디).', required: false })
  @IsOptional()
  @IsEmail()
  email?: string;
}
