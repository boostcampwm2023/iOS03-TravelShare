import {
  BadRequestException,
  Injectable,
  Logger,
  NotFoundException,
  OnModuleInit,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post } from 'entities/post.entity';
import { Equal, In, Not, Raw, Repository } from 'typeorm';
import { plainToInstance } from 'class-transformer';
import { PostDetailResponse } from './post.detail.response.dto';
import { Authentication } from 'auth/authentication.dto';
import { PostDetailQuery } from './post.detail.query.dto';
import { Transactional } from 'typeorm-transactional';
import { PostUploadBody } from './post.upload.body.dto';
import { PostUploadResponse } from './post.upload.response.dto';
import { Route } from 'entities/route.entity';
import { PostLikeResponse } from './post.like.response.dto';
import {
  PostContentElement,
  jsonToPoint,
} from 'entities/post.content.element.entity';
import { Place } from 'entities/place.entity';
import { PostSearchResponse } from './post.search.response.dto';
import { PostSearchQuery } from './post.search.query.dto';
import { PostFindQuery } from './post.find.query.dto';
import { PostFindResponse } from './post.find.response.dto';
import { PostConfig } from './post.config.dto';
import { Cron } from '@nestjs/schedule';
import { PostLikeQuery } from './post.like.query.dto';
import { PostListQuery } from './post.list.query.dto';
import { PostCacheRepository } from './post.cache.repository';

const { all: allPromise } = Promise;
const { min } = Math;
const all: typeof Promise.all = allPromise.bind(Promise);

@Injectable()
export class PostService implements OnModuleInit {
  private readonly logger: Logger = new Logger(PostService.name);

  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(PostContentElement)
    private readonly postContentElementRepository: Repository<PostContentElement>,
    @InjectRepository(Route)
    private readonly routeRepository: Repository<Route>,
    @InjectRepository(Place)
    private readonly placeRepository: Repository<Place>,
    private readonly postCacheRepository: PostCacheRepository,
    private readonly postConfig: PostConfig,
  ) {}

  @Transactional()
  async upload(post: PostUploadBody, { email }: Authentication) {
    const routeId = await this.saveOrGetRouteId(post);
    const {
      identifiers: [{ postId }],
    } = await this.postRepository.insert({
      ...post,
      writer: { email },
      route: { routeId },
    });
    await this.postContentElementRepository.insert(
      post.contents.map((content) => ({
        ...content,
        post: { postId },
      })),
    );
    // 이미 들어있는 엔티티
    post.pins ??= [];
    const placeIds = (
      await this.placeRepository.find({
        where: { placeId: In(post.pins.map(({ placeId }) => placeId)) },
      })
    ).map(({ placeId }) => placeId);
    const { identifiers: places } = await this.placeRepository.insert(
      post.pins.filter(({ placeId }) => !placeIds.includes(placeId)),
    );
    await this.postRepository
      .createQueryBuilder()
      .relation('pins')
      .of(postId)
      .add([...places.map(({ placeId }) => placeId), ...placeIds]);
    return plainToInstance(PostUploadResponse, {
      postId,
    });
  }

  private async saveOrGetRouteId({ route }: PostUploadBody): Promise<number> {
    if (!route || !route.coordinates || route.coordinates?.length === 0) {
      return null;
    }
    const {
      identifiers: [{ routeId }],
    } = await this.routeRepository.insert({ ...route, routeId: null });
    return routeId;
  }

  /**
   *
   * ```sql
   * SELECT
   *   `place`.`place_id` AS `place_place_id`,
   *   `place`.`place_name` AS `place_place_name`,
   *   `place`.`phone_number` AS `place_phone_number`,
   *   `place`.`category` AS `place_category`,
   *   `place`.`address` AS `place_address`,
   *   `place`.`road_address` AS `place_road_address`,
   *   ST_AsText(`place`.`coordinate`) AS `place_coordinate`,
   *   `post_count`.*
   * FROM `place` `place`
   * INNER JOIN
   * (
   *  SELECT
   *    COUNT(post_id) AS `postNum`,
   *    place_id
   *  FROM `pins` `pins`
   *  GROUP BY place_id
   * ) `post_count`
   * ON post_count.place_id=`place`.`place_id`
   * WHERE ST_CONTAINS(
   *  ST_BUFFER(`place`.`coordinate`, 100),
   *  ST_GEOMFROMTEXT(?, 4326)
   * )
   * ORDER BY postNum DESC
   * ```
   * @param param0
   * @returns
   */
  async findByPlaceId({ placeId }: PostFindQuery) {
    const { coordinate } = await this.placeRepository
      .findOneOrFail({
        where: { placeId },
        select: ['coordinate'],
      })
      .catch((err) => {
        this.logger.error(err);
        throw new NotFoundException(`place ${placeId} not found`, {
          cause: err,
        });
      });
    const { raw, entities } = await this.placeRepository
      .createQueryBuilder('place')
      .select()
      .innerJoinAndSelect(
        (qb) => {
          return qb
            .select('COUNT(pins.post_id)', 'postNum')
            .addSelect('place_id')
            .from('pins', 'pins')
            .innerJoin('post', 'post', 'pins.post_id=post.post_id')
            .where('post.public=:true', { true: true })
            .groupBy('place_id');
        },
        'post_count',
        'post_count.place_id=place.place_id',
      )
      .where(
        `ST_CONTAINS(ST_BUFFER(place.coordinate, 10000), ST_GEOMFROMTEXT(:point, 4326))`,
        { point: jsonToPoint(coordinate) },
      )
      .andWhere({ placeId: Not(Equal(placeId)) })
      .orderBy('postNum', 'DESC')
      .getRawAndEntities();

    return plainToInstance(
      PostFindResponse,
      entities.map((place, index) => ({
        ...place,
        postNum: raw[index].postNum,
      })),
    );
  }

  async list(
    { sortBy, ...pagination }: PostListQuery,
    { email }: Authentication,
  ) {
    let postIds: number[];
    switch (sortBy) {
      case 'top':
        postIds = await this.postCacheRepository.getTopScorePostIds(
          pagination.skip,
          pagination.take,
        );
        break;
      case 'latest':
        const posts = await this.postRepository.find({
          where: { public: true },
          order: {
            postId: 'DESC',
          },
          ...pagination,
        });
        postIds = posts.map(({ postId }) => postId);
        break;
    }

    const posts =
      await this.postCacheRepository.getMultiPostWithLockAsideAndWriteAroundStrategy(
        postIds,
      );

    return plainToInstance(
      PostSearchResponse,
      await all(
        posts.map(async (post) => ({
          ...post,
          liked: await this.postCacheRepository.isLikedUser(post.postId, email),
        })),
      ),
    );
  }

  async detail({ postId }: PostDetailQuery, { email }: Authentication) {
    const post =
      await this.postCacheRepository.getPostWithLockAsideAndWriteAroundStrategy(
        postId,
      );
    if (post.public !== true && post.writer.email !== email) {
      throw new BadRequestException('비공개 게시글입니다.');
    }
    if (!(await this.postCacheRepository.isViewedUser(postId, email))) {
      await this.postCacheRepository.addViewedUser(postId, email);
    }
    return plainToInstance(PostDetailResponse, {
      ...post,
      liked: await this.postCacheRepository.isLikedUser(postId, email),
    });
  }

  async search(
    {
      title,
      content,
      keyword,
      username,
      email,
      placeId,
      ...pagination
    }: PostSearchQuery,
    user: Authentication,
  ) {
    if (!(title || content || keyword || username || email || placeId)) {
      throw new BadRequestException(`One of query must be provided`);
    }
    const postIds = (
      await this.postRepository.find({
        where: [
          {
            ...(title
              ? {
                  public: true,
                  title: Raw((alias) => `MATCH(${alias}) AGAINST(:title)`, {
                    title,
                  }),
                }
              : {}),
          },
          {
            ...(content
              ? {
                  public: true,
                  contents: {
                    description: Raw(
                      (alias) => `MATCH(${alias}) AGAINST(:content)`,
                      {
                        content,
                      },
                    ),
                  },
                }
              : {}),
          },
          ...(keyword
            ? [
                {
                  public: true,
                  title: Raw((alias) => `MATCH(${alias}) AGAINST(:title)`, {
                    title: keyword,
                  }),
                },
                {
                  contents: {
                    description: Raw(
                      (alias) => `MATCH(${alias}) AGAINST(:description)`,
                      {
                        description: keyword,
                      },
                    ),
                  },
                },
              ]
            : []),
          {
            ...(username
              ? {
                  public: true,
                  writer: {
                    name: Raw((alias) => `MATCH(${alias}) AGAINST(:username)`, {
                      username,
                    }),
                  },
                }
              : {}),
          },
          {
            ...(email
              ? {
                  public: email === user.email ? null : true,
                  writer: { email },
                }
              : {}),
          },
          {
            ...(placeId
              ? {
                  public: email === user.email ? null : true,
                  pins: { placeId },
                }
              : {}),
          },
        ],
        ...pagination,
        ...(email || placeId
          ? {
              order: {
                postId: 'DESC',
              },
            }
          : {}),
        select: { postId: true },
      })
    ).map(({ postId }) => postId);
    if (postIds.length === 0) {
      return plainToInstance(PostSearchResponse, []);
    }
    const posts =
      await this.postCacheRepository.getMultiPostWithLockAsideAndWriteAroundStrategy(
        postIds,
      );

    return plainToInstance(
      PostSearchResponse,
      await all(
        posts.map(async (post) => ({
          ...post,
          liked: await this.postCacheRepository.isLikedUser(
            post.postId,
            user.email,
          ),
        })),
      ),
    );
  }

  async like({ postId }: PostLikeQuery, { email }: Authentication) {
    await this.postCacheRepository.addOrRemoveLikedUser(postId, email);
    return plainToInstance(PostLikeResponse, {
      postId,
      likeNum: await this.postCacheRepository.getLikedUsersCount(postId),
      liked: await this.postCacheRepository.isLikedUser(postId, email),
    });
  }

  @Cron('0 0 * * * *')
  async updateTaskToViewsAndLikesAndScores() {
    const { alpha, beta, gamma } = this.postConfig;
    this.logger.debug(
      `cache persisting starts. alpha: ${alpha}, beta: ${beta}, gamma: ${gamma}`,
    );

    const updateList = await this.postCacheRepository.getUpdatedPostIds();
    const posts = await this.postRepository.find({
      where: { postId: In(updateList) },
      relations: { likedUsers: true },
      select: {
        postId: true,
        viewNum: true,
        score: true,
        likedUsers: {
          email: true,
        },
      },
    });

    await all(
      posts.map(async (post) => {
        const incrementedViewNum =
          await this.postCacheRepository.getIncrementedViewedUsersCount(
            post.postId,
          );
        const incrementedlikeNum = min(
          (await this.postCacheRepository.getLikedUsersCount(post.postId)) -
            post.likedUsers.length,
        );
        //update score
        this.postRepository.update(post.postId, {
          viewNum: post.viewNum + incrementedViewNum,
          score:
            post.score !== 0
              ? alpha * post.score +
                (1 - alpha) *
                  ((1 - beta) * incrementedViewNum +
                    beta * incrementedlikeNum) *
                  (gamma / (post.score + 1))
              : (1 - beta) * incrementedViewNum + beta * incrementedlikeNum,
        });

        const oldLikedUsers = post.likedUsers.map(({ email }) => email);
        const currentlyLikedUsers =
          await this.postCacheRepository.getLikedUserEmails(post.postId);

        const unlikedUsers = oldLikedUsers.filter(
          (email) => !currentlyLikedUsers.includes(email),
        );
        const likedUsers = currentlyLikedUsers.filter(
          (email) => !oldLikedUsers.includes(email),
        );

        this.postRepository
          .createQueryBuilder()
          .relation('likedUsers')
          .of(post.postId)
          .remove(unlikedUsers);
        this.postRepository
          .createQueryBuilder()
          .relation('likedUsers')
          .of(post.postId)
          .add(likedUsers);

        this.postCacheRepository.cleanPostViewdUsers(post.postId);
        this.postCacheRepository.cleanPostLikedUsers(post.postId);
      }),
    ).catch((err) => {
      this.logger.error(err);
    });

    await this.postCacheRepository.cleanPostUpdatedIds();
    await this.postCacheRepository.updateTopPostsScoreZSet();

    this.logger.debug('cache persistenced');
  }

  async onModuleInit() {
    await this.postCacheRepository.updateTopPostsScoreZSet();
  }
}
