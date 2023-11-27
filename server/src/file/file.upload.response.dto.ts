import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsUrl } from 'class-validator';

export class FileUploadResponse {
  @ApiProperty({ description: '파일 URL입니다.' })
  @IsUrl()
  url: string;

  @ApiProperty({ description: '파일 etag' })
  @IsString()
  etag: string;
}
