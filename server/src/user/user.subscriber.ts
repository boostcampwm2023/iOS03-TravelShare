import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { User } from 'entities/user.entity';
import { PostCacheableService } from 'post/post.cacheable.service';
import {
  DataSource,
  EntitySubscriberInterface,
  EventSubscriber,
  In,
  RemoveEvent,
  UpdateEvent,
} from 'typeorm';

@EventSubscriber()
@Injectable()
export class UserSubscriber implements EntitySubscriberInterface<User> {
  constructor(
    private readonly postCacheableService: PostCacheableService,
    @InjectDataSource()
    private readonly dataSource: DataSource,
  ) {
    dataSource.subscribers.push(this);
  }

  async beforeRemove(event: RemoveEvent<User>): Promise<any> {
    const { entity } = event;
    const repository = event.manager.getRepository(User);
    const user = await repository.findOne({
      where: {
        email: entity.email,
      },
      relations: {
        followees: true,
        followers: true,
      },
    });
    if (user.followees.length > 0) {
      await repository.decrement(
        {
          email: In(user.followees.map(({ email }) => email)),
        },
        'followersNum',
        1,
      );
    }
    if (user.followers.length > 0) {
      await repository.decrement(
        {
          email: In(user.followers.map(({ email }) => email)),
        },
        'followeesNum',
        1,
      );
    }
    await this.postCacheableService.deleteLikedUserOnAllPosts(entity.email);
  }
}
