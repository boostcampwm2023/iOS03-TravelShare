import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsPositive, Max } from 'class-validator';

export class PostPagenation {
  @ApiProperty({ description: '몇 개까지? 최대 15개' })
  @Max(30)
  @IsPositive()
  @IsOptional()
  take?: number = 10;

  @ApiProperty({ description: 'offset' })
  @IsPositive()
  @IsOptional()
  skip?: number = 10;
}