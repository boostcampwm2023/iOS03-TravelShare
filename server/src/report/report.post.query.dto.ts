import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsInt, IsOptional, IsString, Min } from 'class-validator';

export class ReportPostQuery {
  @ApiProperty({ description: '게시글 id' })
  @Transform(({ value }) => parseInt(value))
  @IsInt()
  @Min(0)
  postId: number;

  @ApiProperty({ description: '신고 제목', required: false })
  @IsString()
  @IsOptional()
  title: string;

  @ApiProperty({ description: '신고 내용', required: false })
  @IsString()
  @IsOptional()
  description: string;
}
