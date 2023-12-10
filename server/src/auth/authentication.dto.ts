import { IsEmail, IsIn, IsString } from 'class-validator';

export class Authentication {
  @IsEmail()
  email: string;

  @IsString()
  @IsIn(['user', 'admin'])
  role: 'user' | 'admin';
}
