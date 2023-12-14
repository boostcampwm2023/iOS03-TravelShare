import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsString } from 'class-validator';

export class PostKeywordAutoCompleteResponse {
  @ApiProperty({ description: '자동 검색어 완성 결과' })
  @IsArray()
  @IsString({ each: true })
  keywords: string[];
}
