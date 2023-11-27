import { Module } from '@nestjs/common';
import { PostController } from './post.controller';
import { PostService } from './post.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Post } from 'entities/post.entity';
import { Route } from 'entities/route.entity';
import { PostContentElement } from 'entities/post.content.element.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Post, PostContentElement, Route])],
  controllers: [PostController],
  providers: [PostService],
})
export class PostModule {}
