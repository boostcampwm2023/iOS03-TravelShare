import { ApiProperty } from '@nestjs/swagger';
import { IsEmail } from 'class-validator';

export class UserDeleteBody {
  @ApiProperty({ description: 'id email' })
  @IsEmail()
  email: string;
}
