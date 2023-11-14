import { IsEmail, IsIn, IsString } from 'class-validator';

export class AuthenticationDto {
  @IsEmail()
  email: string;

  @IsString()
  @IsIn(['user', 'admin'])
  role: string;
}
