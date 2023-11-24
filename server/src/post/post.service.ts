import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post, PostContentElement } from 'src/entities/post.entity';
import { Like, Raw, Repository } from 'typeorm';
import { PostWriteBody } from './post.write.body';
import { PostFindQuery } from './post.find.query.dto';
import { plainToInstance } from 'class-transformer';
import { PostFindResponse } from './post.find.response.dto';
import { PostHitsQuery } from './post.hist.query.dto';
import { PostDetailResponse } from './post.detail.response.dto';
import { Authentication } from 'src/auth/authentication.dto';
import { PostDetailQuery } from './post.detail.query.dto';
import { Transactional } from 'typeorm-transactional';

@Injectable()
export class PostService {
  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(PostContentElement)
    private readonly postContentElementRepository: Repository<PostContentElement>,
  ) {}

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
      },
      ...(pagination ?? { take: 10 }),
      order: {
        likeNum: 'DESC',
        viewNum: 'DESC',
      },
      relations: {
        writer: true,
      },
      relationLoadStrategy: 'join',
    });

    return plainToInstance(
      PostFindResponse,
      await Promise.all(
        posts.map(async (post) => ({
          ...post,
          liked: await this.postRepository.exist({
            where: { likeUsers: { email } },
          }),
        })),
      ),
    );
  }

  async search(
    { title, username, ...pagination }: PostFindQuery,
    { email }: Authentication,
  ) {
    const posts = await this.postRepository.find({
      where: [
        { ...(title ? { title: Like(`%${title}%`) } : {}) },
        { ...(username ? { writer: Like(`%${username}%`) } : {}) },
      ],
      ...pagination,
      relations: {
        writer: true,
      },
    });
    return plainToInstance(
      PostFindResponse,
      await Promise.all(
        posts.map(async (post) => ({
          ...post,
          liked: await this.postRepository.exist({
            where: { likeUsers: { email } },
          }),
        })),
      ),
    );
  }

  async find({ email }: { email: string }) {
    return await this.postRepository.findBy({ writer: { email } });
  }

  @Transactional()
  async detail({ postId }: PostDetailQuery, { email }: Authentication) {
    const post = await this.postRepository.findOneOrFail({
      where: { postId },
      relationLoadStrategy: 'query',
      relations: {
        contents: true,
        writer: true,
      },
    });

    // await this.postRepository.increment({ postId }, 'viewNum', 1);
    await this.postRepository.update(
      { postId },
      { viewNum: () => 'view_num + 1' },
    );
    return plainToInstance(PostDetailResponse, {
      ...post,
      liked: await this.postRepository.exist({
        where: { likeUsers: { email } },
      }),
    });
  }

  @Transactional()
  async upload(post: PostWriteBody, { email }: Authentication) {
    const result = await this.postRepository.insert(post);
    const contents = await this.postContentElementRepository.insert(
      post.contents,
    );
    await this.postRepository
      .createQueryBuilder()
      .relation('contents')
      .of(result.identifiers[0].postId)
      .add(
        contents.identifiers.map(
          ({ postContentElemntId }) => postContentElemntId,
        ),
      );
    await this.postRepository
      .createQueryBuilder()
      .relation('writer')
      .of(result.identifiers[0].postId)
      .set(email);
  }

  @Transactional()
  async like({ postId }: PostDetailQuery, { email }: Authentication) {
    const liked = await this.isLiked(postId, email);
    if (liked) {
      return await this.unlikeInternal(postId, email);
    } else {
      return await this.likeInternal(postId, email);
    }
  }

  private async isLiked(postId: number, email: string) {
    return await this.postRepository.exist({
      where: {
        postId,
        likeUsers: { email },
      },
    });
  }

  private async likeInternal(postId: number, email: string) {
    await this.postRepository
      .createQueryBuilder()
      .relation('likeUsers')
      .of(postId)
      .add(email);
    return await this.postRepository.update(postId, {
      likeNum: () => 'like_num + 1',
    });
  }

  private async unlikeInternal(postId: number, email: string) {
    await this.postRepository
      .createQueryBuilder()
      .relation('likeUsers')
      .of(postId)
      .remove(email);
    return await this.postRepository.update(postId, {
      likeNum: () => 'like_num - 1',
    });
  }
}
