import { IsNumberString } from 'class-validator';
import { PostPagination } from './post.pagination.dto';
import { ApiProperty } from '@nestjs/swagger';

export class PostFindQuery extends PostPagination {
  @ApiProperty({ description: '핀 위치 placeId' })
  @IsNumberString()
  placeId: string;
}
