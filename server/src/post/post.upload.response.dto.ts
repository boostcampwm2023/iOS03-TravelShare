import { ApiProperty } from '@nestjs/swagger';
import { IsNumber } from 'class-validator';

export class PostUploadResponse {
  @ApiProperty({ description: '게시글 고유 id입니다.' })
  @IsNumber()
  postId: number;
}
