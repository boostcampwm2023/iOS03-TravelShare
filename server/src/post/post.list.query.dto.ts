import { IsIn, IsInt, IsOptional, Max, Min } from 'class-validator';

export class PostListQuery {
  @IsInt()
  @Min(0)
  @IsOptional()
  skip: number = 0;

  @IsInt()
  @Min(0)
  @Max(30)
  @IsOptional()
  take: number = 10;

  @IsIn(['latest', 'top'])
  @IsOptional()
  sortBy: 'latest' | 'top' = 'top';
}
