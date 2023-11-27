import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class PostKeywordAutoCompleteQuery {
  @ApiProperty({ description: '자동완성 요청 키워드' })
  @IsString()
  keyword: string;
}
