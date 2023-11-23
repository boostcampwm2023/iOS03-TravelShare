import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsPositive } from 'class-validator';

export class PostDetailQuery {
  @ApiProperty({ description: '게시글 id' })
  @IsPositive()
  @IsInt()
  postId: number;
}
