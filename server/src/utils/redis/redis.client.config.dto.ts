import { Type } from 'class-transformer';
import { IsNumber, IsString, ValidateNested } from 'class-validator';

export class RedisClientConfig {
  @IsString()
  url: string;

  @ValidateNested()
  @Type(() => RedisClientConfigSocket)
  socket?: RedisClientConfigSocket;

  @IsString()
  username: string;

  @IsString()
  password: string;

  @IsString()
  name: string;
}

class RedisClientConfigSocket {
  @IsNumber()
  port: number;

  @IsString()
  host: string;
}
