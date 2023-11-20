import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsString } from 'class-validator';

export class KakaoSearchAccuracyQuery {
  @ApiProperty({ description: '키워드' })
  @IsString()
  keyword: string;

  @ApiProperty({ description: '페이지' })
  @IsNumber()
  pagenum: number;
}
