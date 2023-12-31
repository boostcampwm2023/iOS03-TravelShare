import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsInt, IsOptional, IsPositive, Max, Min } from 'class-validator';

export class PostPagination {
  @ApiProperty({
    description: '몇 개까지? 최대 15개',
    required: false,
    maximum: 30,
    minimum: 0,
    default: 10,
  })
  @Transform(({ value }) => parseInt(value))
  @IsPositive()
  @Max(30)
  @IsOptional()
  take?: number = 10;

  @ApiProperty({
    description: 'offset',
    required: false,
    minimum: 0,
    default: 0,
  })
  @Transform(({ value }) => parseInt(value))
  @IsInt()
  @Min(0)
  @IsOptional()
  skip?: number = 0;
}
