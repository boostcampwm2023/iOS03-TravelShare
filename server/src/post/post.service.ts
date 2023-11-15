import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Post, PostContentElement } from 'src/entities/post.entity';
import { Repository } from 'typeorm';
import { PostWriteBody } from './post.write.body';
import { Transactional } from 'src/utils/transactional.decorator';
import {
  PostFindMyLogQuery,
  PostFindOtherUserLogQuery,
} from './post.find.query.dto';

@Injectable()
export class PostService {
  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(PostContentElement)
    private readonly postContentElementRepository: Repository<PostContentElement>,
  ) {}

  async popularList(query: PostFindMyLogQuery) {
    return await this.postRepository.find({
      ...query,
      order: {
        likeNum: 'DESC',
        viewNum: 'DESC',
      },
    });
  }

  async findByUser(query: PostFindOtherUserLogQuery) {
    const opts = {
      order: {
        likeNum: 'DESC' as const,
        viewNum: 'DESC' as const,
      },
      take: query.take ?? 10,
      skip: query.skip ?? 0,
    };
    if (query.mode === 'liked') {
      return await this.postRepository.find({
        ...opts,
        where: {
          likeUsers: {
            email: query.email,
          },
        },
      });
    } else {
      return await this.postRepository.find({
        ...opts,
        where: {
          writer: {
            email: query.email,
          },
        },
      });
    }
  }

  async detail(id: number) {
    return await this.postRepository.findOneOrFail({
      where: {
        postId: id,
      },
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
  async like(userEmail: string, postId: number) {
    const isLiked = await this.postRepository.exist({
      where: {
        postId,
        likeUsers: {
          email: userEmail,
        },
      },
    });
    if (isLiked) {
      throw new BadRequestException('already liked');
    }
    await this.postRepository
      .createQueryBuilder()
      .relation('likeUsers')
      .of(postId)
      .add(userEmail);
  }

  @Transactional()
  async unlike(userEmail: string, postId: number) {
    const isLiked = await this.postRepository.exist({
      where: {
        postId,
        likeUsers: {
          email: userEmail,
        },
      },
    });
    if (!isLiked) {
      throw new BadRequestException('already unliked');
    }
    await this.postRepository
      .createQueryBuilder()
      .relation('likeUsers')
      .of(postId)
      .remove(userEmail);
  }
}
