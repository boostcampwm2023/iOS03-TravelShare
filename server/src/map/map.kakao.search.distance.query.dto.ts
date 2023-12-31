import { ApiProperty } from '@nestjs/swagger';
import { KakaoSearchAccuracyQuery } from './map.kakao.search.accuracy.query.dto';
import { IsNumberString } from 'class-validator';

export class KakaoSearchDistanceQuery extends KakaoSearchAccuracyQuery {
  @ApiProperty({ description: 'x 좌표' })
  @IsNumberString()
  x: number;

  @ApiProperty({ description: 'y 좌표' })
  @IsNumberString()
  y: number;
}
