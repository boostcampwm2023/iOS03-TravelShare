import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from 'entities/user.entity';
import { PostModule } from 'post/post.module';
import { UserSubscriber } from './user.subscriber';

@Module({
  imports: [TypeOrmModule.forFeature([User]), PostModule],
  controllers: [UserController],
  providers: [UserService, UserSubscriber],
})
export class UserModule {}
