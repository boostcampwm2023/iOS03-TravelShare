import {
  Injectable,
  Logger,
  NotFoundException,
  OnModuleInit,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post } from 'entities/post.entity';
import { SchemaFieldTypes } from 'redis';
import { In, Repository } from 'typeorm';
import { RedisService } from 'utils/redis/redis.service';

@Injectable()
export class PostCacheableService implements OnModuleInit {
  private readonly logger: Logger = new Logger(PostCacheableService.name);

  private readonly REDIS_POST_TOP_SCORE_ZSET_KEY = `post:top:scores`;
  private readonly REDIS_POST_BODY_KEY_PREFIX = `post:body`;
  private readonly REDIS_POST_VIEWED_USERS_PREFIX = `post:viewdusers`;
  private readonly REDIS_POST_LIKED_USERS_PREFIX = `post:likedusers`;
  private readonly REDIS_POST_VIEWED_USERS_LOADED_LIST_KEY =
    'post:viewdusers:loadedlist';
  private readonly REDIS_POST_LIKED_USERS_LOADED_LIST_KEY =
    'post:likedusers:loadedlist';
  private readonly REDIS_POST_BODY_INDEX_KEY = `post:body:index`;

  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    private readonly redisService: RedisService,
  ) {}

  private getBodyKey(postId: number) {
    return `${this.REDIS_POST_BODY_KEY_PREFIX}:${postId}`;
  }

  private getViewdUsersKey(postId: number) {
    return `${this.REDIS_POST_VIEWED_USERS_PREFIX}:${postId}`;
  }

  private getLikedUsersKey(postId: number) {
    return `${this.REDIS_POST_LIKED_USERS_PREFIX}:${postId}`;
  }

  async getIncrementedViewedUsersCount(postId: number) {
    return await this.redisService.setCard(this.getViewdUsersKey(postId));
  }

  async getLikedUsersCount(postId: number) {
    if (
      !(await this.redisService.setIsMember(
        this.REDIS_POST_LIKED_USERS_LOADED_LIST_KEY,
        postId,
      ))
    ) {
      await this.redisService.setAdd(
        this.REDIS_POST_LIKED_USERS_LOADED_LIST_KEY,
        postId,
      );
      const { likedUsers } = await this.postRepository.findOneOrFail({
        where: { postId },
        select: { likedUsers: true },
        relations: { likedUsers: true },
      });
      if (likedUsers.length === 0) {
        return 0;
      }
      await this.redisService.setAdd(
        this.getLikedUsersKey(postId),
        likedUsers.map(({ email }) => email),
      );
    }
    return await this.redisService.setCard(this.getLikedUsersKey(postId));
  }

  async isViewedUser(postId: number, email: string) {
    return await this.redisService.setIsMember(
      this.getViewdUsersKey(postId),
      email,
    );
  }

  async isLikedUser(postId: number, email: string) {
    if (
      !(await this.redisService.setIsMember(
        this.REDIS_POST_LIKED_USERS_LOADED_LIST_KEY,
        postId,
      ))
    ) {
      await this.redisService.setAdd(
        this.REDIS_POST_LIKED_USERS_LOADED_LIST_KEY,
        postId,
      );
      const { likedUsers } = await this.postRepository.findOneOrFail({
        where: { postId },
        select: { likedUsers: true },
        relations: { likedUsers: true },
      });
      if (likedUsers.length === 0) {
        return false;
      }
      await this.redisService.setAdd(
        this.getLikedUsersKey(postId),
        likedUsers.map(({ email }) => email),
      );
    }
    return await this.redisService.setIsMember(
      this.getLikedUsersKey(postId),
      email,
    );
  }

  async addViewedUser(postId: number, email: string) {
    await this.redisService.setAdd(
      this.REDIS_POST_VIEWED_USERS_LOADED_LIST_KEY,
      postId,
    );
    await this.redisService.setAdd(this.getViewdUsersKey(postId), email);
  }

  async addOrRemoveLikedUser(postId: number, email: string) {
    if (
      !(await this.redisService.setIsMember(
        this.REDIS_POST_LIKED_USERS_LOADED_LIST_KEY,
        postId,
      ))
    ) {
      const { likedUsers } = await this.postRepository
        .findOneOrFail({
          where: { postId },
          relations: { likedUsers: true },
        })
        .catch((err) => {
          this.logger.error(err);
          throw new NotFoundException(`user not found`, { cause: err });
        });
      const likedEmails = likedUsers.map(({ email }) => email);
      // const updateEmails =  [
      //   ...likedEmails,
      //   ...(likedEmails.includes(email) ? [email] : []),
      // ]
      const updateEmails = likedEmails.filter(
        (likedEmail) => likedEmail !== email,
      );
      if (updateEmails.length === 0) {
        return;
      }
      await this.redisService.setAdd(
        this.getLikedUsersKey(postId),
        updateEmails,
      );
    } else {
      if (
        await this.redisService.setIsMember(
          this.getLikedUsersKey(postId),
          email,
        )
      ) {
        await this.redisService.setRemove(this.getLikedUsersKey(postId), email);
      } else {
        await this.redisService.setAdd(this.getLikedUsersKey(postId), email);
      }
    }
  }

  async deleteLikedUserOnAllPosts(email: string) {
    const posts = await this.getUpdatedPostIds();
    posts.forEach(async (postId) => {
      await this.redisService.setRemove(this.getLikedUsersKey(postId), email);
    });
  }

  async evictPostsByWriterEmail(email: string) {
    const client = this.redisService.getClient();
    const { documents } = await client.ft.search(
      this.REDIS_POST_BODY_INDEX_KEY,
      `@email:{${email.replace(/[\@\.]/g, '\\$&')}}`,
    );
    const keys = documents.map(({ id }) => id);
    if (keys.length > 0) {
      await this.redisService.del(...keys);
    }
  }

  async getPostWithLockAsideAndWriteAroundStrategy(
    postId: number,
  ): Promise<Post & { likeNum: number }> {
    //lock aside
    const cache = await this.redisService.jsonGet<Post>(
      this.getBodyKey(postId),
    );
    if (!cache) {
      //cache miss
      const post = await this.postRepository
        .findOneOrFail({
          where: { postId },
          relations: {
            writer: true,
            contents: true,
            route: true,
            pins: true,
            likedUsers: true,
          },
        })
        .catch((err) => {
          throw new NotFoundException('post not found', { cause: err });
        });

      //write around
      await this.redisService.jsonSet({
        key: this.getBodyKey(post.postId),
        value: { ...post, likedUsers: undefined },
        expire: 500,
      });

      return {
        ...post,
        viewNum:
          post.viewNum +
          (await this.getIncrementedViewedUsersCount(post.postId)),
        likeNum: await this.getLikedUsersCount(post.postId),
      };
    } else {
      return {
        ...cache,
        viewNum:
          cache.viewNum +
          (await this.getIncrementedViewedUsersCount(cache.postId)),
        likeNum: await this.getLikedUsersCount(cache.postId),
      };
    }
  }

  async getMultiPostWithLockAsideAndWriteAroundStrategy(postIds: number[]) {
    if (!postIds || postIds.length === 0) {
      return [];
    }
    const caches = await this.redisService.jsonGet<Post>(
      postIds.map((postId) => this.getBodyKey(postId)),
    );
    const missings = postIds.filter((postId, index) => !caches[index]);
    if (missings.length > 0) {
      const posts = await this.postRepository.find({
        where: {
          postId: In(missings),
        },
        relations: {
          writer: true,
          contents: true,
          route: true,
          pins: true,
          likedUsers: true,
        },
      });
      await this.redisService.jsonSet(
        ...posts.map((post) => ({
          key: this.getBodyKey(post.postId),
          value: { ...post, likedUsers: undefined },
          expire: 500,
        })),
      );
      posts.forEach(async ({ postId, likedUsers }) => {
        if (
          await this.redisService.setIsMember(
            this.REDIS_POST_LIKED_USERS_LOADED_LIST_KEY,
            postId,
          )
        ) {
          return;
        }
        await this.redisService.setAdd(
          this.REDIS_POST_LIKED_USERS_LOADED_LIST_KEY,
          postId,
        );
        if (likedUsers.length === 0) {
          return;
        }
        await this.redisService.setAdd(
          this.getLikedUsersKey(postId),
          likedUsers.map(({ email }) => email),
        );
      });
      postIds.forEach((postId, index) => {
        if (!caches[index]) {
          caches[index] = posts.find((post) => post.postId === postId);
        }
      });
    }
    return await Promise.all(
      caches
        .filter((cache) => cache)
        .map(async (cache) => ({
          ...cache,
          viewNum:
            cache.viewNum +
            (await this.getIncrementedViewedUsersCount(cache.postId)),
          likeNum: await this.getLikedUsersCount(cache.postId),
        })),
    );
  }

  async getIncrementedViewedUserEmails(postId: number) {
    return await this.redisService.setMembers(this.getViewdUsersKey(postId));
  }

  async getLikedUserEmails(postId: number) {
    return await this.redisService.setMembers(this.getLikedUsersKey(postId));
  }

  async getUpdatedPostIds() {
    return (
      await this.redisService.setUnion([
        this.REDIS_POST_VIEWED_USERS_LOADED_LIST_KEY,
        this.REDIS_POST_LIKED_USERS_LOADED_LIST_KEY,
      ])
    ).map((postId) => parseInt(postId));
  }

  async getTopScorePostIds(skip: number, take: number) {
    return (
      await this.redisService.zRange(
        this.REDIS_POST_TOP_SCORE_ZSET_KEY,
        skip,
        skip + take,
        { reverse: true },
      )
    ).map((value) => parseInt(value));
  }

  async updateTopPostsScoreZSet() {
    const postIdAndScores = (
      await this.postRepository.find({
        where: {
          public: true,
        },
        order: { score: 'DESC' },
        select: {
          postId: true,
          score: true,
        },
      })
    ).map(({ postId, score }) => ({ value: postId, score }));
    await this.redisService.del(this.REDIS_POST_TOP_SCORE_ZSET_KEY);
    if (postIdAndScores.length === 0) {
      return;
    }
    await this.redisService.zAdd(
      this.REDIS_POST_TOP_SCORE_ZSET_KEY,
      ...postIdAndScores,
    );
  }

  async cleanPostUpdatedIds() {
    return await this.redisService.del(
      this.REDIS_POST_LIKED_USERS_LOADED_LIST_KEY,
      this.REDIS_POST_VIEWED_USERS_LOADED_LIST_KEY,
    );
  }

  async cleanPostViewdUsers(postId: number) {
    return await this.redisService.del(this.getViewdUsersKey(postId));
  }

  async cleanPostLikedUsers(postId: number) {
    return await this.redisService.del(this.getLikedUsersKey(postId));
  }

  async onModuleInit() {
    try {
      await this.redisService
        .getClient()
        .ft.info(this.REDIS_POST_BODY_INDEX_KEY);
    } catch (err) {
      await this.redisService.getClient().ft.create(
        this.REDIS_POST_BODY_INDEX_KEY,
        {
          '$.writer.email': {
            type: SchemaFieldTypes.TAG,
            AS: 'email',
          },
        },
        {
          ON: 'JSON',
          PREFIX: this.REDIS_POST_BODY_KEY_PREFIX,
        },
      );
    }
  }
}
