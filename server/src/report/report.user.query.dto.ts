import { ApiProperty } from '@nestjs/swagger';
import { IsEmail } from 'class-validator';

export class ReportUserQuery {
  @ApiProperty()
  @IsEmail()
  email: string;
}
