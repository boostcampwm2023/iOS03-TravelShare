import { Module } from '@nestjs/common';
import { PostController } from './post.controller';
import { PostService } from './post.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Post, PostContentElement } from 'src/entities/post.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Post, PostContentElement])],
  controllers: [PostController],
  providers: [PostService],
})
export class PostModule {}
