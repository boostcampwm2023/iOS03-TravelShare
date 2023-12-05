import { createClient } from 'redis';

export type RedisClient = ReturnType<typeof createClient>;
