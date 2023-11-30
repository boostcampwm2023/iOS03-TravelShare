import { IsIn, IsOptional, IsString } from 'class-validator';
import { PostPagination } from './post.pagination.dto';
import { ApiProperty } from '@nestjs/swagger';

export class PostSortable extends PostPagination {
  @ApiProperty({
    enum: ['hot', 'latest'],
    description: 'hot: 인기도 순, latest: 최신순',
    required: false,
    default: 'hot',
  })
  @IsIn(['hot', 'latest'])
  @IsString()
  @IsOptional()
  sortBy: 'hot' | 'latest' = 'hot';
}
