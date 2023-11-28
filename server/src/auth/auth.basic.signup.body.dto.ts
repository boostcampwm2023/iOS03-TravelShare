import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString, IsUrl, MaxLength } from 'class-validator';
import { AuthBasicSigninBody } from './auth.basic.signin.body.dto';

export class AuthBasicSignupBody extends AuthBasicSigninBody {
  @ApiProperty({ description: '이름', required: false })
  @IsString()
  @MaxLength(30)
  @IsOptional()
  name: string;

  @ApiProperty({
    description: '이미지 url',
    required: false,
    example: 'https://image.url/here/optional',
  })
  @IsUrl()
  @IsOptional()
  imageUrl?: string;

  @ApiProperty({
    description: '자기소개',
    required: false,
    example: '자기소개는 옵셔널입니다.',
  })
  @IsString()
  @IsOptional()
  introduce?: string;
}
