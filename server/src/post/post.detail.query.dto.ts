import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsPositive } from 'class-validator';

export class PostDetailQuery {
  @ApiProperty({ description: '게시글 id' })
  @Transform(({ value }) => Number.parseInt(value))
  @IsPositive()
  postId: number;
}
