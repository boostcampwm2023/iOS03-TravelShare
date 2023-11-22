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
import { PostReadResponse } from './post.read.response.dto';

@Injectable()
export class PostService {
  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(PostContentElement)
    private readonly postContentElementRepository: Repository<PostContentElement>,
  ) {}

  async popularList(pagination: PostHitsQuery) {
    return plainToInstance(
      PostFindResponse,
      await this.postRepository.find({
        where: {
          createdAt: MoreThan(new Date(Date.now() - 1000 * 60 * 60 * 24 * 30)),
        },
        ...(pagination ?? { take: 15 }),
        order: {
          likeNum: 'DESC',
          viewNum: 'DESC',
        },
      }),
    );
  }

  async search({ title, username, ...pagination }: PostFindQuery) {
    return plainToInstance(
      PostFindResponse,
      await this.postRepository.find({
        where: {
          ...(title ? { title: Like(title) } : {}),
          ...(username ? { writer: { name: username } } : {}),
        },
        ...pagination,
      }),
    );
  }

  async find({ email }: { email: string }) {
    return await this.postRepository.findBy({ writer: { email } });
  }

  async detail(id: number) {
    return plainToInstance(
      PostReadResponse,
      await this.postRepository.findOneOrFail({
        where: {
          postId: id,
        },
        relationLoadStrategy: 'query',
        relations: {
          contents: true,
          writer: true,
        },
      }),
    );
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
  async like(userEmail: string, postId: number) {
    const liked = await this.isLiked(userEmail, postId);
    console.log(liked);
    if (liked) {
      return await this.unlikeInternal(userEmail, postId);
    } else {
      return await this.likeInternal(userEmail, postId);
    }
  }

  private async isLiked(userEmail: string, postId: number) {
    return await this.postRepository.exist({
      where: {
        postId,
        likeUsers: { email: userEmail },
      },
    });
  }

  async likeInternal(userEmail: string, postId: number) {
    await this.postRepository
      .createQueryBuilder()
      .relation('likeUsers')
      .of(postId)
      .add(userEmail);
    return await this.postRepository.update(postId, {
      likeNum: () => 'like_num + 1',
    });
  }

  async unlikeInternal(userEmail: string, postId: number) {
    await this.postRepository
      .createQueryBuilder()
      .relation('likeUsers')
      .of(postId)
      .remove(userEmail);
    return await this.postRepository.update(postId, {
      likeNum: () => 'like_num - 1',
    });
  }
}
