import {
  Inject,
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { REDIS_CLIENT } from './redis.client.provide.token';
import { RedisClient } from './redis.client.type';
import { SetOptions } from 'redis';

@Injectable()
export class RedisService {
  private readonly logger: Logger = new Logger(RedisService.name);

  constructor(
    @Inject(REDIS_CLIENT)
    private readonly client: RedisClient,
  ) {}

  async set(key: string, value: any, options?: SetOptions) {
    return await this.client.set(key, value, options);
  }

  async get(key: string): Promise<string>;
  async get(...keys: string[]): Promise<string[]>;
  async get(...keys: string[]) {
    switch (keys.length) {
      case 0:
        this.logger.error('redis.get must have not less than 1 key arguments');
        throw new InternalServerErrorException('redis arguments error');
      case 1:
        return await this.client.get(keys[0]);
      default:
        return await this.client.mGet(keys);
    }
  }

  async del(key: string) {
    return await this.client.del(key);
  }

  async exists(...key: string[]) {
    return await this.client.exists(key);
  }

  async jsonSet(key: string, object: Record<string, any>, path?: string) {
    return await this.client.json.set(key, path ?? '.', object);
  }

  async jsonMSet(items: { key: string; value: any; path?: string }[]) {
    return await this.client.json.mSet(
      items.map((item) => ({ path: '.', ...item })),
    );
  }

  async jsonGet(key: string, path?: string): Promise<any>;
  async jsonGet(key: string, ...paths: string[]): Promise<any[]> {
    if (paths.length === 0) {
      paths = ['.'];
    }
    const result = await this.client.json.get(key, {
      path: paths,
    });
    return paths.length === 1 ? result?.[0] : result;
  }

  async jsonMGet(keys: string[]) {
    return await this.client.json.mGet(keys, '.');
  }

  async jsonExists(key: string, path?: string) {
    try {
      await this.client.json.type(key, path);
      return true;
    } catch (err) {
      return false;
    }
  }

  async jsonKeys(key: string, path: string = '$') {
    return await this.client.json.objKeys(key, path);
  }

  async jsonIncrement(key: string, path: string, num: number) {
    return await this.client.json.numIncrBy(key, path, num);
  }

  async hashSet(key: string, field: string, value: any) {
    return await this.client.hSet(key, field, value);
  }

  async hashGet(key: string): Promise<any[]>;
  async hashGet(key: string, field: string): Promise<any>;
  async hashGet(key: string, ...fields: string[]): Promise<any[]>;
  async hashGet(key: string, ...fields: string[]) {
    switch (fields.length) {
      case 0:
        return await this.client.hGetAll(key);
      case 1:
        return await this.client.hGet(key, fields[0]);
      default:
        return await this.client.hmGet(key, fields);
    }
  }

  async hashGetAll(key: string) {
    return await this.client.hGetAll(key);
  }

  async hashDel(key: string, field: string) {
    await this.client.hDel(key, field);
  }

  async hashExists(key: string, field: string) {
    return await this.client.hExists(key, field);
  }

  async hashIncrBy(key: string, field: string, increment: number) {
    return await this.client.hIncrBy(key, field, increment);
  }

  async setAdd(key: string, ...values: any[]) {
    return await this.client.sAdd(key, values);
  }

  async setRem(key: string, ...values: any[]) {
    return await this.client.sRem(key, values);
  }

  async setMembers(key: string) {
    return await this.client.sMembers(key);
  }

  async setIsMember(key: string, value: any) {
    return await this.client.sIsMember(key, value);
  }

  async setCard(key: string) {
    return await this.client.sCard(key);
  }

  async zAdd(key: string, value: any, score: number) {
    await this.client.zAdd(key, {
      score,
      value,
    });
  }

  async zMAdd(key: string, members: { value: any; score: number }[]) {
    await this.client.zAdd(key, members);
  }

  async zIncrBy(key: string, value: any, incrementScore: number) {
    return await this.client.zIncrBy(key, incrementScore, value);
  }

  async zScore(key: string, value: any) {
    return await this.client.zScore(key, value);
  }

  async zRangeAll(key: string, offset?: number, count?: number) {
    return await this.client.zRange(key, 0, -1, {
      ...(offset && count
        ? {
            LIMIT: {
              offset: offset,
              count: count,
            },
          }
        : {}),
    });
  }

  async zRangeByLex(
    key: string,
    min: any,
    max: any,
    offset?: number,
    count?: number,
  ) {
    return await this.client.zRange(key, min, max, {
      BY: 'LEX',
      ...(offset && count
        ? {
            LIMIT: {
              offset: offset,
              count: count,
            },
          }
        : {}),
    });
  }
}
