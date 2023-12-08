import { Inject, Injectable, Logger, Scope } from '@nestjs/common';
import { RedisService } from './redis/redis.service';
import { INQUIRER } from '@nestjs/core';

// TODO:
const SPECIAL_CHARACTER_REGEXP = /[^\w|가-힣|\s]/gi;

// export class TrieNode {
//   children: Record<string, TrieNode> = {};
//   eow: number = 0;
// }

@Injectable({ scope: Scope.TRANSIENT })
export class KeywordAutoCompleteService {
  private logger: Logger;
  private context: string;

  constructor(
    @Inject(INQUIRER)
    private readonly parant: object,
    private readonly redisService: RedisService,
  ) {
    this.context = `${this.parant?.constructor?.name}:${KeywordAutoCompleteService.name}`;
    this.logger = new Logger(this.context);
  }

  async insert(word: string): Promise<void> {
    word = word.replace(SPECIAL_CHARACTER_REGEXP, '');
    if (
      !(
        typeof (await this.redisService.zScore(this.context, word)) === 'number'
      )
    ) {
      await this.redisService.zAdd(this.context, { value: word, score: 0 });
    }
  }

  async search(word: string) {
    this.logger.debug(`search: ${word}`);
    return await this.redisService.zRangeByLex(
      this.context,
      `[${word}`,
      `[${word}\xff`,
    );
  }
}
