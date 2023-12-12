import { Module } from '@nestjs/common';
import { AppleAuthController } from './apple.auth.controller';
import { AppleAuthService } from './apple.auth.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppleAuth } from 'entities/apple.auth.entity';
import { User } from 'entities/user.entity';
import { Post } from 'entities/post.entity';
import { PostModule } from 'post/post.module';

@Module({
  imports: [TypeOrmModule.forFeature([AppleAuth, User, Post]), PostModule],
  controllers: [AppleAuthController],
  providers: [AppleAuthService],
})
export class AppleAuthModule {}
