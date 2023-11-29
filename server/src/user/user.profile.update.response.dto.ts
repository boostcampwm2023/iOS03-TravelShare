import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsEmpty, IsNumber, IsOptional, IsString, IsUrl } from 'class-validator';

export class UserProfileUpdateResponse {
  @ApiProperty({default: 'user updated'})
  @IsString()
  message: string = 'user updated';

  @ApiProperty({default: null})
  @IsEmpty()
  error: any = null;

  @ApiProperty({default: 200})
  @IsNumber()
  statusCode: number = 200;
}
