import { Type } from 'class-transformer';
import {
  IsObject,
  IsOptional,
  IsString,
  ValidateNested,
} from 'class-validator';
import { RedisClientConfigSocket } from './redis.client.config.socket.dto';

export class RedisClientConfig {
  @IsString()
  @IsOptional()
  url: string;

  @ValidateNested()
  @Type(() => RedisClientConfigSocket)
  @IsObject()
  @IsOptional()
  socket?: RedisClientConfigSocket;

  @IsString()
  @IsOptional()
  username: string;

  @IsString()
  @IsOptional()
  password: string;

  @IsString()
  @IsOptional()
  name: string;
}
