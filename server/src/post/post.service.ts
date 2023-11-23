import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post, PostContentElement } from 'src/entities/post.entity';
import { Like, MoreThan, Repository } from 'typeorm';
import { PostWriteBody } from './post.write.body';
import { Transactional } from 'src/utils/transactional.decorator';
import { PostFindQuery } from './post.find.query.dto';
import { plainToInstance } from 'class-transformer';
import { PostFindResponse } from './post.find.response.dto';
import { PostHitsQuery } from './post.hist.query.dto';
import { PostDetailResponse } from './post.detail.response.dto';
import { Authentication } from 'src/auth/authentication.dto';
import { PostDetailQuery } from './post.detail.query.dto';

@Injectable()
export class PostService {
  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(PostContentElement)
    private readonly postContentElementRepository: Repository<PostContentElement>,
  ) {}

  async popularList(pagination: PostHitsQuery, { email }: Authentication) {
    const posts = await this.postRepository.find({
      where: {
        createdAt: MoreThan(new Date(Date.now() - 1000 * 60 * 60 * 24 * 30)),
      },
      ...(pagination ?? { take: 10 }),
      order: {
        likeNum: 'DESC',
        viewNum: 'DESC',
      },
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

  async search(
    { title, username, ...pagination }: PostFindQuery,
    { email }: Authentication,
  ) {
    console.log(
      await this.postRepository.find({
        where: {
          title: Like(`%${title}%`),
        },
      }),
    );
    const posts = await this.postRepository.find({
      where: {
        ...(title ? { title: Like(`%${title}%`) } : {}),
        ...(username ? { writer: { name: username } } : {}),
      },
      ...pagination,
      relations: {
        writer: true,
      },
    });
    console.log(posts);
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

  async detail({ postId }: PostDetailQuery, { email }: Authentication) {
    const post = await this.postRepository.findOneOrFail({
      where: { postId },
      relationLoadStrategy: 'query',
      relations: {
        contents: true,
        writer: true,
      },
    });
    return plainToInstance(PostDetailResponse, {
      ...post,
      liked: await this.postRepository.exist({
        where: { likeUsers: { email } },
      }),
    });
  }

  @Transactional()
  async upload(post: PostWriteBody) {
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
