import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, MaxLength, MinLength } from 'class-validator';

export class AuthBasicSigninBody {
  @ApiProperty({ description: '이메일', example: 'macro@macro.com' })
  @IsEmail()
  email: string;

  @ApiProperty({
    description: '비밀번호',
    minLength: 8,
    example: 'passwordMoreThan8Characters',
  })
  @IsString()
  @MinLength(8)
  @MaxLength(50)
  password: string;
}
