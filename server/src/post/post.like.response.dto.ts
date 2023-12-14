import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsNumber, IsOptional, Min } from 'class-validator';

export class PostLikeResponse {
  @ApiProperty({ description: '해당 게시글 좋아요 수 입니다.' })
  @IsNumber()
  @Min(0)
  likeNum: number;

  @ApiProperty({ description: '게시글 고유 id 입니다.' })
  @IsNumber()
  @Min(0)
  @IsOptional()
  postId: number;

  @ApiProperty({ description: '좋아요 여부입니다.' })
  @IsBoolean()
  liked: boolean;
}
