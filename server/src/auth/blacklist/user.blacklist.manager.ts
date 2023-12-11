import { Injectable } from '@nestjs/common';
import { RedisService } from 'utils/redis/redis.service';

@Injectable()
export class UserBlackListManager {
  private readonly REDIS_USER_REVOKED_PREFIX = `user:revoked`;
  private readonly EXPIRATION_TIME_MILLISECONDS = 2592000000;
  constructor(private readonly redisService: RedisService) {}

  private getRevokedUserKey(email: string) {
    return `${this.REDIS_USER_REVOKED_PREFIX}:${email}`;
  }

  async addRevokedBlacklist(email: string) {
    await this.redisService.set(this.getRevokedUserKey(email), Date.now(), {
      EX: this.EXPIRATION_TIME_MILLISECONDS,
    });
  }

  async isRevokedOn({ email, iss }: { email: string; iss: number }) {
    const isRevoked = await this.redisService.get(
      this.getRevokedUserKey(email),
    );
    if (!isRevoked) {
      return false;
    }
    return parseInt(isRevoked) > iss;
  }
}
