import { Global, Module } from '@nestjs/common';
import { ConfigManagerModule } from 'config/config.manager.module';
import { RedisClientConfig } from './redis.client.config.dto';
import { REDIS_CLIENT } from './redis.client.provide.token';
import { redisClientFactory } from './redis.client.factory';
import { RedisService } from './redis.service';

@Global()
@Module({
  imports: [
    ConfigManagerModule.registerAs({
      schema: RedisClientConfig,
      path: 'redis',
    }),
  ],
  providers: [
    {
      inject: [RedisClientConfig],
      provide: REDIS_CLIENT,
      useFactory: redisClientFactory,
    },
    RedisService,
  ],
  exports: [RedisService],
})
export class RedisModule {}
