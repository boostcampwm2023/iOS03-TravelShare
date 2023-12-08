import {
  Inject,
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { REDIS_CLIENT } from './redis.client.provide.token';
import { RedisClient } from './redis.client.type';
import { SetOptions } from 'redis';

type RedisJsonSetItem = {
  key: string;
  value: any;
  expire?: number;
};

type ZMember = {
  score: number;
  value: any;
};

@Injectable()
export class RedisService {
  private readonly logger: Logger = new Logger(RedisService.name);

  constructor(
    @Inject(REDIS_CLIENT)
    private readonly client: RedisClient,
  ) {}

  getClient(): RedisClient {
    return this.client;
  }

  async set(key: string, value: string | number, options: SetOptions) {
    return await this.client.set(key, value, options);
  }

  async get<T>(key: string): Promise<T>;
  async get<T>(keys: string[]): Promise<T[]>;
  async get(keyOrkeys: string | string[]) {
    if (typeof keyOrkeys === 'string') {
      return await this.client.get(keyOrkeys);
    } else if (Array.isArray(keyOrkeys)) {
      return await this.client.mGet(keyOrkeys);
    } else {
      this.logger.error(`invalid arg ${keyOrkeys} on get`);
      throw new InternalServerErrorException('invalid command error');
    }
  }

  async del(...keys: string[]) {
    switch (keys.length) {
      case 0:
        this.logger.error('invalid arg on del');
        throw new InternalServerErrorException('invalid command error');
      default:
        return await this.client.del(keys);
    }
  }

  async jsonSet(item: RedisJsonSetItem): Promise<any>;
  async jsonSet(...items: RedisJsonSetItem[]): Promise<any>;
  async jsonSet(...items: RedisJsonSetItem[]) {
    switch (items.length) {
      case 0:
        this.logger.error(`invalid arg on json.set`);
        throw new InternalServerErrorException(`Invalid command error`);
      case 1:
        const [{ key, value, expire }] = items;
        if (expire) {
          return await this.client
            .multi()
            .json.set(key, '.', value)
            .expire(key, expire)
            .exec();
        } else {
          return await this.client.json.set(key, '.', value);
        }
      default:
        let command = this.client.multi();
        for (const { key, value, expire } of items) {
          command = command.json.set(key, '.', value);
          if (expire) {
            command = command.expire(key, expire);
          }
        }
        return await command.exec();
    }
  }

  async jsonGet<T>(key: string): Promise<T>;
  async jsonGet<T>(keys: string[]): Promise<T[]>;
  async jsonGet(keyOrkeys: string | string[]) {
    if (typeof keyOrkeys === 'string') {
      return await this.client.json.get(keyOrkeys);
    } else if (Array.isArray(keyOrkeys)) {
      return await this.client.json.mGet(keyOrkeys, '.');
    } else {
      this.logger.error(`invalid arg ${keyOrkeys} on json.get`);
      throw new InternalServerErrorException(`invalid command error`);
    }
  }

  async setAdd(key: string, members: any | any[]) {
    if (Array.isArray(members)) {
      if (members.length === 0) {
        this.logger.error(`invalid arg ${key},${members} on setadd`);
        throw new InternalServerErrorException('invalid command error');
      }
      members = members.map((member) => this.getRedisArgumentValue(member));
    } else {
      members = this.getRedisArgumentValue(members);
    }
    return await this.client.sAdd(key, members as string[]);
  }

  async setCard(key: string): Promise<number> {
    return await this.client.sCard(key);
  }

  async setRemove(key: string, ...members: any[]) {
    members = members.map((member) => this.getRedisArgumentValue(member));
    return await this.client.sRem(key, members as string[]);
  }

  async setIsMember(key: string, member: any): Promise<boolean> {
    return await this.client.sIsMember(key, this.getRedisArgumentValue(member));
  }

  async setMembers(key: string): Promise<string[]> {
    return await this.client.sMembers(key);
  }

  async setUnion(keys: string[]): Promise<string[]> {
    return await this.client.sUnion(keys);
  }

  async zAdd(key: string, ...members: ZMember[]) {
    return await this.client.zAdd(
      key,
      members.map(({ value, score }) => ({
        value: this.getRedisArgumentValue(value),
        score,
      })),
    );
  }

  async zRange(key: string, min: number, max: number) {
    return await this.client.zRange(key, min, max);
  }

  async zScore(key: string, member: any) {
    return await this.client.zScore(key, member);
  }

  async zRangeByLex(key: string, min: string, max: string) {
    return await this.client.zRangeByLex(key, min, max);
  }

  private getRedisArgumentValue(value: any): string {
    switch (typeof value) {
      case 'string':
        return value;
      case 'boolean':
      case 'bigint':
      case 'object':
      case 'function':
      case 'symbol':
      case 'number':
        return value.toString();
      default:
        return 'null';
    }
  }
}
