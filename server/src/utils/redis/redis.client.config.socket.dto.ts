import { IsNumber, IsOptional, IsString } from 'class-validator';

export class RedisClientConfigSocket {
  @IsNumber()
  @IsOptional()
  port: number;

  @IsString()
  @IsOptional()
  host: string;
}
