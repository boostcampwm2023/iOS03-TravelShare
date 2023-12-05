import { Transform } from 'class-transformer';
import { IsNumber } from 'class-validator';

export class PostConfig {
  @IsNumber()
  @Transform(({ value }) =>
    typeof value === 'string' ? parseInt(value) : value,
  )
  alpha: number;

  @IsNumber()
  @Transform(({ value }) =>
    typeof value === 'string' ? parseInt(value) : value,
  )
  beta: number;

  @IsNumber()
  @Transform(({ value }) =>
    typeof value === 'string' ? parseInt(value) : value,
  )
  gamma: number;
}
