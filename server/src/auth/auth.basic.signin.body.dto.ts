import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, MaxLength, MinLength } from 'class-validator';

export class AuthBasicSigninBody {
  @ApiProperty({ description: 'id email' })
  @IsEmail()
  email: string;

  @ApiProperty({ description: 'password' })
  @IsString()
  @MinLength(8)
  @MaxLength(50)
  password: string;
}