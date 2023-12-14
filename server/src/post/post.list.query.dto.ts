import { IsIn, IsOptional } from 'class-validator';
import { PostPagination } from './post.pagination.dto';
import { ApiProperty } from '@nestjs/swagger';

export class PostListQuery extends PostPagination {
  @ApiProperty({
    description: '분류 기준(top = hot)',
    default: 'top',
    required: false,
    enum: ['top', 'latest'],
  })
  @IsIn(['latest', 'top'])
  @IsOptional()
  sortBy: 'latest' | 'top' = 'top';
}
