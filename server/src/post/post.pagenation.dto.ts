import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsOptional, IsPositive, Max, Min } from 'class-validator';

export class PostPagenation {
  @ApiProperty({
    description: '몇 개까지? 최대 15개',
    required: false,
    maximum: 30,
    minimum: 0,
  })
  @Max(30)
  @IsPositive()
  @IsOptional()
  take?: number = 10;

  @ApiProperty({ description: 'offset', required: false, minimum: 0 })
  @IsInt()
  @Min(0)
  @IsOptional()
  skip?: number = 0;
}
