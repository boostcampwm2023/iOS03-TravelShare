import { createClient } from 'redis';
import { RedisClientConfig } from './redis.client.config.dto';

export const redisClientFactory = async (options: RedisClientConfig) => {
  return await createClient(options).connect();
};
