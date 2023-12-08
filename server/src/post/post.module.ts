import { Module } from '@nestjs/common';
import { PostController } from './post.controller';
import { PostService } from './post.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Post } from 'entities/post.entity';
import { Route } from 'entities/route.entity';
import { PostContentElement } from 'entities/post.content.element.entity';
import { Place } from 'entities/place.entity';
import { User } from 'entities/user.entity';
import { ConfigManagerModule } from 'config/config.manager.module';
import { PostConfig } from './post.config.dto';
import { PostCacheRepository } from './post.cache.repository';

@Module({
  imports: [
    TypeOrmModule.forFeature([Post, PostContentElement, Route, Place, User]),
    ConfigManagerModule.registerAs({
      schema: PostConfig,
      path: 'application.post',
    }),
  ],
  controllers: [PostController],
  providers: [PostService, PostCacheRepository],
})
export class PostModule {}
