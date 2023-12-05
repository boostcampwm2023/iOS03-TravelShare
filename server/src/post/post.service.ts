import {
  BadRequestException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post } from 'entities/post.entity';
import { Equal, In, Not, Raw, Repository } from 'typeorm';
import { plainToInstance } from 'class-transformer';
import { PostHitsQuery } from './post.hits.query.dto';
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
import { User } from 'entities/user.entity';
import { RedisService } from 'utils/redis/redis.service';
import { Cron } from '@nestjs/schedule';
import { PostConfig } from './post.config.dto';

const { all: allPromise } = Promise;
const { min, random, floor } = Math;
const all: typeof Promise.all = allPromise.bind(Promise);

@Injectable()
export class PostService {
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
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly redisService: RedisService,
    private readonly postConfig: PostConfig,
  ) {}

  private readonly REDIS_POST_UPDATED_IDS_SETS_KEY = 'post:updated:id:sets';

  private readonly REDIS_POST_VIEWED_USERS_SETS_KEY = 'post:viewed:users:sets';

  private readonly REDIS_POST_LIKED_USERS_SETS_KEY = 'post:liked:users:sets';

  private getRedisPostViewdUsersSetsKey(postId: number) {
    return `${this.REDIS_POST_VIEWED_USERS_SETS_KEY}:${postId}`;
  }

  private getRedisPostLikedUsersSetsKey(postId: number) {
    return `${this.REDIS_POST_LIKED_USERS_SETS_KEY}:${postId}`;
  }

  private async addPostUpdatedId(postId: number) {
    return await this.redisService.setAdd(
      this.REDIS_POST_UPDATED_IDS_SETS_KEY,
      postId.toString(),
    );
  }

  private async getPostUpdatedIds() {
    return (
      await this.redisService.setMembers(this.REDIS_POST_UPDATED_IDS_SETS_KEY)
    ).map((value) => parseInt(value));
  }

  private async addPostViewdUsers(postId: number, ...email: string[]) {
    await this.addPostUpdatedId(postId);
    return await this.redisService.setAdd(
      this.getRedisPostViewdUsersSetsKey(postId),
      ...email,
    );
  }

  private async addPostLikedUsers(postId: number, ...email: string[]) {
    await this.addPostUpdatedId(postId);
    return await this.redisService.setAdd(
      this.getRedisPostLikedUsersSetsKey(postId),
      ...email,
    );
  }

  private async remPostLikedUsers(postId: number, ...email: string[]) {
    return await this.redisService.setRem(
      this.getRedisPostLikedUsersSetsKey(postId),
      ...email,
    );
  }

  private async isPostViewdUsersCached(postId: number) {
    return await this.redisService.exists(
      this.getRedisPostViewdUsersSetsKey(postId),
    );
  }

  private async isPostLikedUsersCached(postId: number) {
    return await this.redisService.exists(
      this.getRedisPostLikedUsersSetsKey(postId),
    );
  }

  private async loadPostLikedUsersAndGetCount(postId: number) {
    const likedUsers = await this.userRepository.find({
      where: { likedPosts: { postId } },
    });
    if (likedUsers.length === 0) {
      return 0;
    }
    return await this.redisService.setAdd(
      this.getRedisPostLikedUsersSetsKey(postId),
      ...likedUsers.map(({ email }) => email),
    );
  }

  private async getPostViewdUsersCount(postId: number) {
    return await this.redisService.setCard(
      this.getRedisPostViewdUsersSetsKey(postId),
    );
  }

  private async getPostLikedUsersCount(postId: number) {
    return await this.redisService.setCard(
      this.getRedisPostLikedUsersSetsKey(postId),
    );
  }

  private async getPostViewdUsersList(postId: number) {
    return await this.redisService.setMembers(
      this.getRedisPostViewdUsersSetsKey(postId),
    );
  }

  private async getPostLikedUsersList(postId: number) {
    return await this.redisService.setMembers(
      this.getRedisPostLikedUsersSetsKey(postId),
    );
  }

  private async isViewdUser(postId: number, email: string) {
    return await this.redisService.setIsMember(
      this.getRedisPostViewdUsersSetsKey(postId),
      email,
    );
  }

  private async isLikedUser(postId: number, email: string) {
    return await this.redisService.setIsMember(
      this.getRedisPostLikedUsersSetsKey(postId),
      email,
    );
  }

  private async isLikedUserWithCheckCache(postId: number, email: string) {
    if (!(await this.isPostLikedUsersCached(postId))) {
      await this.loadPostLikedUsersAndGetCount(postId);
    }

    return await this.isLikedUser(postId, email);
  }

  private async cleanPostUpdatedIds() {
    return await this.redisService.del(this.REDIS_POST_UPDATED_IDS_SETS_KEY);
  }

  private async cleanPostViewdUsers(postId: number) {
    return await this.redisService.del(
      this.getRedisPostViewdUsersSetsKey(postId),
    );
  }

  private async cleanPostLikedUsers(postId: number) {
    return await this.redisService.del(
      this.getRedisPostLikedUsersSetsKey(postId),
    );
  }

  private async loadCacheAndGetCounts(postId: number) {
    if (!(await this.isPostLikedUsersCached(postId))) {
      await this.loadPostLikedUsersAndGetCount(postId);
    }
    return {
      viewNum: await this.getPostViewdUsersCount(postId),
      likeNum: await this.getPostLikedUsersCount(postId),
    };
  }

  /**
   * 인기 게시글을 불러옵니다.<br>
   * 한 달 이후 등록된 게시물 중,<br>
   * 좋아요 수와 조회수를 기준으로 정렬하여 게시글들을 불러옵니다.<br>
   * 이후 각 게시글마다 좋아요를 한 유저들 중 현재 로그인한 유저가 포함되어 있는지 각각 조사하여 liked를 표시합니다.<br>
   * #####  TODO: 각 게시글에 대한 좋아요 여부를 표시할 것인가?<br>
   * #####  최적화 필요
   * 
   * # 첫번째 쿼리
   * 
   * ```sql
   * 
SELECT `post`.`post_id`     AS `Post_post_id`,
       `post`.`title`       AS `Post_title`,
       `post`.`view_num`    AS `Post_view_num`,
       `post`.`like_num`    AS `Post_like_num`,
       `post`.`summary`     AS `Post_summary`,
       `post`.`route`       AS `Post_route`,
       `post`.`hashtag`     AS `Post_hashtag`,
       `post`.`start_at`    AS `Post_start_at`,
       `post`.`end_at`      AS `Post_end_at`,
       `post`.`created_at`  AS `Post_created_at`,
       `post`.`modified_at` AS `Post_modified_at`,
       `post`.`deleted_at`  AS `Post_deleted_at`,
       `post`.`user_email`  AS `Post_user_email`
FROM   `post` `Post`
WHERE  (( Date_add(Now(), INTERVAL -2 week) <= `post`.`created_at` ))
       AND ( `post`.`deleted_at` IS NULL )
ORDER  BY `post`.`like_num` DESC,
          `post`.`view_num` DESC
LIMIT  10 
   * ```
   *
   * # 두번쨰
   *
   * ```sql
SELECT `user`.`user_id`     AS `User_user_id`,
       `user`.`email`       AS `User_email`,
       `user`.`name`        AS `User_name`,
       `user`.`password`    AS `User_password`,
       `user`.`image_url`   AS `User_image_url`,
       `user`.`role`        AS `User_role`,
       `user`.`created_at`  AS `User_created_at`,
       `user`.`modified_at` AS `User_modified_at`,
       `user`.`deleted_at`  AS `User_deleted_at`
FROM   `user` `User`
       INNER JOIN `post` `Post`
               ON `post`.`user_email` = `user`.`email`
                  AND `post`.`deleted_at` IS NULL
WHERE  ( `post`.`post_id` IN ( ?, ?, ?, ?,
                               ?, ?, ?, ?,
                               ?, ? ) )
       AND ( `user`.`deleted_at` IS NULL ) -- PARAMETERS: [3,5,8,11,14,2,6,9,12,15]

   * ```
   * # 나머지 쿼리들       
   * ```sql
SELECT `post`.`post_id`    AS `Post_postId`,
       `post`.`user_email` AS `User_writer_email`
FROM   `post` `Post`
WHERE  ( `post`.`post_id` IN ( 3, 5, 8, 11,
                               14, 2, 6, 9,
                               12, 15 ) )
       AND ( `post`.`deleted_at` IS NULL );

SELECT 1 AS `row_exists`
FROM   (SELECT 1 AS dummy_column) `dummy_table`
WHERE  EXISTS (SELECT 1
               FROM   `post` `Post`
                      LEFT JOIN `post_likes_users` `Post_Post__Post_likeUsers`
                             ON
       `Post_Post__Post_likeUsers`.`post_id` = `post`.`post_id`
                      LEFT JOIN `user` `Post__Post_likeUsers`
                             ON `Post__Post_likeUsers`.`email` =
                                `Post_Post__Post_likeUsers`.`email`
                                AND ( `Post__Post_likeUsers`.`deleted_at` IS
                                      NULL )
               WHERE  (( `Post__Post_likeUsers`.`email` = ? ))
                      AND ( `post`.`deleted_at` IS NULL ))
LIMIT  1 -- PARAMETERS: ["macro@macrocd.com"]

   * ```
   * ```
SELECT 
  DISTINCT `distinctAlias`.`Post_post_id` AS `ids_Post_post_id`, 
  `distinctAlias`.`Post_like_num`, 
  `distinctAlias`.`Post_view_num` 
FROM 
  (
    SELECT 
      `Post`.`post_id` AS `Post_post_id`, 
      `Post`.`title` AS `Post_title`, 
      `Post`.`view_num` AS `Post_view_num`, 
      `Post`.`like_num` AS `Post_like_num`, 
      `Post`.`summary` AS `Post_summary`, 
      `Post`.`route` AS `Post_route`, 
      `Post`.`hashtag` AS `Post_hashtag`, 
      `Post`.`start_at` AS `Post_start_at`, 
      `Post`.`end_at` AS `Post_end_at`, 
      `Post`.`created_at` AS `Post_created_at`, 
      `Post`.`modified_at` AS `Post_modified_at`, 
      `Post`.`deleted_at` AS `Post_deleted_at`, 
      `Post`.`user_email` AS `Post_user_email`, 
      `Post__Post_writer`.`user_id` AS `Post__Post_writer_user_id`, 
      `Post__Post_writer`.`email` AS `Post__Post_writer_email`, 
      `Post__Post_writer`.`name` AS `Post__Post_writer_name`, 
      `Post__Post_writer`.`password` AS `Post__Post_writer_password`, 
      `Post__Post_writer`.`image_url` AS `Post__Post_writer_image_url`, 
      `Post__Post_writer`.`role` AS `Post__Post_writer_role`, 
      `Post__Post_writer`.`created_at` AS `Post__Post_writer_created_at`, 
      `Post__Post_writer`.`modified_at` AS `Post__Post_writer_modified_at`, 
      `Post__Post_writer`.`deleted_at` AS `Post__Post_writer_deleted_at` 
    FROM 
      `post` `Post` 
      LEFT JOIN `user` `Post__Post_writer` ON `Post__Post_writer`.`email` = `Post`.`user_email` 
      AND (
        `Post__Post_writer`.`deleted_at` IS NULL
      ) 
    WHERE 
      (
        (
          DATE_ADD(NOW(), INTERVAL -2 WEEK) <= `Post`.`created_at`
        )
      ) 
      AND (`Post`.`deleted_at` IS NULL)
  ) `distinctAlias` 
ORDER BY 
  `distinctAlias`.`Post_like_num` DESC, 
  `distinctAlias`.`Post_view_num` DESC, 
  `Post_post_id` ASC 
LIMIT 
  10

SELECT 
  `Post`.`post_id` AS `Post_post_id`, 
  `Post`.`title` AS `Post_title`, 
  `Post`.`view_num` AS `Post_view_num`, 
  `Post`.`like_num` AS `Post_like_num`, 
  `Post`.`summary` AS `Post_summary`, 
  `Post`.`route` AS `Post_route`, 
  `Post`.`hashtag` AS `Post_hashtag`, 
  `Post`.`start_at` AS `Post_start_at`, 
  `Post`.`end_at` AS `Post_end_at`, 
  `Post`.`created_at` AS `Post_created_at`, 
  `Post`.`modified_at` AS `Post_modified_at`, 
  `Post`.`deleted_at` AS `Post_deleted_at`, 
  `Post`.`user_email` AS `Post_user_email`, 
  `Post__Post_writer`.`user_id` AS `Post__Post_writer_user_id`, 
  `Post__Post_writer`.`email` AS `Post__Post_writer_email`, 
  `Post__Post_writer`.`name` AS `Post__Post_writer_name`, 
  `Post__Post_writer`.`password` AS `Post__Post_writer_password`, 
  `Post__Post_writer`.`image_url` AS `Post__Post_writer_image_url`, 
  `Post__Post_writer`.`role` AS `Post__Post_writer_role`, 
  `Post__Post_writer`.`created_at` AS `Post__Post_writer_created_at`, 
  `Post__Post_writer`.`modified_at` AS `Post__Post_writer_modified_at`, 
  `Post__Post_writer`.`deleted_at` AS `Post__Post_writer_deleted_at` 
FROM 
  `post` `Post` 
  LEFT JOIN `user` `Post__Post_writer` ON `Post__Post_writer`.`email` = `Post`.`user_email` 
  AND (
    `Post__Post_writer`.`deleted_at` IS NULL
  ) 
WHERE 
  (
    (
      DATE_ADD(NOW(), INTERVAL -2 WEEK) <= `Post`.`created_at`
    )
  ) 
  AND (`Post`.`deleted_at` IS NULL) 
  AND (
    `Post`.`post_id` IN (3, 5, 8, 11, 14, 15, 2, 6, 9, 12)
  ) 
ORDER BY 
  `Post`.`like_num` DESC, 
  `Post`.`view_num` DESC
   * ```

    $$ \frac{view}{b} $$

   * @param pagination
   * @param param1
   * @returns
   */
  async popularList(pagination: PostHitsQuery, { email }: Authentication) {
    const posts = await this.postRepository.find({
      where: {
        createdAt: Raw(
          (alias) => `DATE_ADD(NOW(), INTERVAL -2 WEEK) <= ${alias}`,
        ),
        public: true,
      },
      ...(pagination ?? { take: 10 }),
      relations: {
        writer: true,
      },
      order: {
        ...(pagination.sortBy === 'hot'
          ? { score: 'DESC' }
          : { postId: 'DESC' }),
      },
    });

    return plainToInstance(
      PostSearchResponse,
      await all(
        posts.map(async (post) => {
          const { viewNum, likeNum } = await this.loadCacheAndGetCounts(
            post.postId,
          );
          return {
            ...post,
            liked: await this.isLiked(post.postId, email),
            viewNum: post.viewNum + viewNum,
            likeNum,
          };
        }),
      ),
    );
  }

  async hits(pagination: PostHitsQuery, { email }: Authentication) {
    const topPosts = await this.postRepository.find({
      where: { public: true },
      relations: { writer: true },
      order:
        pagination.sortBy === 'hot' ? { score: 'DESC' } : { postId: 'DESC' },
      ...pagination,
    });

    const followeePosts = await this.postRepository.find({
      where: { writer: { followers: { email } } },
      relations: { writer: true },
      order: {
        postId: 'DESC',
        score: 'DESC',
      },
      ...pagination,
    });

    return plainToInstance(
      PostSearchResponse,
      await all(
        [
          ...topPosts.slice(0, floor(pagination.take / 2)),
          ...followeePosts.slice(0, floor(pagination.take / 2)),
        ]
          .map(async (post) => {
            const { viewNum, likeNum } = await this.loadCacheAndGetCounts(
              post.postId,
            );
            return {
              ...post,
              liked: await this.isLiked(post.postId, email),
              viewNum: post.viewNum + viewNum,
              likeNum,
            };
          })
          .sort(() => random() - 0.5),
      ),
    );
  }

  @Transactional()
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
    { email: loginUser }: Authentication,
  ) {
    if (!(title || content || keyword || username || email || placeId)) {
      throw new BadRequestException(`One of query must be provided`);
    }
    const posts = await this.postRepository.find({
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
                public: email === loginUser ? null : true,
                writer: { email },
              }
            : {}),
        },
        {
          ...(placeId
            ? {
                public: email === loginUser ? null : true,
                pins: { placeId },
              }
            : {}),
        },
      ],
      ...pagination,
      relations: {
        writer: true,
      },
    });

    return plainToInstance(
      PostSearchResponse,
      await all(
        posts.map(async (post) => {
          const { viewNum, likeNum } = await this.loadCacheAndGetCounts(
            post.postId,
          );
          return {
            ...post,
            liked: await this.isLiked(post.postId, loginUser),
            viewNum: post.viewNum + viewNum,
            likeNum,
          };
        }),
      ),
    );
  }

  @Transactional()
  async detail({ postId }: PostDetailQuery, { email }: Authentication) {
    const post = await this.postRepository
      .findOneOrFail({
        where: { postId },
        relations: {
          contents: true,
          writer: true,
          route: true,
          pins: true,
        },
      })
      .catch((err) => {
        this.logger.error(err);
        throw new NotFoundException('post not found', { cause: err });
      });
    if (post.writer.email !== email && !post.public) {
      if (!post.public) {
        throw new BadRequestException('비공개 게시글입니다.');
      }
    }
    await this.addPostViewdUsers(postId, email);
    const { viewNum, likeNum } = await this.loadCacheAndGetCounts(postId);
    return plainToInstance(PostDetailResponse, {
      ...post,
      writer: {
        ...post.writer,
        followee: await this.userRepository.exist({
          where: {
            email: email,
            followees: {
              email: post.writer.email,
            },
          },
        }),
        follower: await this.userRepository.exist({
          where: {
            email: email,
            followers: {
              email: post.writer.email,
            },
          },
        }),
      },
      liked: await this.isLiked(postId, email),
      viewNum: post.viewNum + viewNum,
      likeNum,
    });
  }

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

  @Transactional()
  async like({ postId }: PostDetailQuery, { email }: Authentication) {
    const liked = await this.isLiked(postId, email);
    if (liked) {
      await this.unlikeInternal(postId, email);
    } else {
      await this.likeInternal(postId, email);
    }

    return plainToInstance(PostLikeResponse, {
      likeNum: await this.getPostLikedUsersCount(postId),
      postId,
      liked: !liked,
    });
  }

  private async isLiked(postId: number, email: string) {
    return await this.isLikedUserWithCheckCache(postId, email);
  }

  private async likeInternal(postId: number, email: string) {
    await this.addPostLikedUsers(postId, email);
  }

  private async unlikeInternal(postId: number, email: string) {
    await this.remPostLikedUsers(postId, email);
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

  @Cron('0 0 * * * *')
  async updateTaskToViewsAndLikesAndScores() {
    const { alpha, beta, gamma } = this.postConfig;
    this.logger.debug(
      `cache persisting starts. alpha: ${alpha}, beta: ${beta}, gamma: ${gamma}`,
    );

    const updateList = await this.getPostUpdatedIds();
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
        const incrementedViewNum = await this.getPostViewdUsersCount(
          post.postId,
        );
        const incrementedlikeNum = min(
          (await this.getPostLikedUsersCount(post.postId)) -
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
                  (gamma / post.score)
              : (1 - beta) * incrementedViewNum + beta * incrementedlikeNum,
        });

        const oldLikedUsers = post.likedUsers.map(({ email }) => email);
        const currentlyLikedUsers = await this.getPostLikedUsersList(
          post.postId,
        );

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

        this.cleanPostViewdUsers(post.postId);
        this.cleanPostLikedUsers(post.postId);
      }),
    ).catch((err) => {
      this.logger.error(err);
    });

    await this.cleanPostUpdatedIds();

    this.logger.debug('cache persistenced');
  }
}
