import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsInt, IsOptional, IsPositive, Max, Min } from 'class-validator';

export class UserPagination {
  @ApiProperty({
    description: '몇 명까지 조회할 것인가?',
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
    description: '몇 번째 결과부터?',
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
