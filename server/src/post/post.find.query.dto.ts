import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';
import { PostPagenation } from './post.pagenation.dto';

export class PostFindQuery extends PostPagenation {
  @ApiProperty({ description: '검색할 제목', required: false })
  @IsString()
  @IsOptional()
  title?: string;

  @ApiProperty({ description: '유저 이름', required: false })
  @IsString()
  @IsOptional()
  username?: string;
}
