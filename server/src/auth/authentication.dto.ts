import { IsEmail, IsIn, IsString } from 'class-validator';

export class AuthUser {
  @IsEmail()
  email: string;

  @IsString()
  @IsIn(['user', 'admin'])
  role: string;
}
