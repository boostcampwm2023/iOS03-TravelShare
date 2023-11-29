import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'entities/user.entity';
import { In, Repository } from 'typeorm';
import { UserProfileUpdateQuery } from './user.profile.update.query.dto';
import { Authentication } from 'auth/authentication.dto';
import { UserProfileResponse } from './user.profile.response.dto';
import { plainToInstance } from 'class-transformer';
import { UserProfileQuery } from './user.profile.query.dto';
import { UserProfileSimpleResponse } from './user.profile.simple.response.dto';
import { Transactional } from 'typeorm-transactional';
import { UserProfileUpdateResponse } from './user.profile.update.response.dto';
import { UserFollowResponse } from './user.follow.response.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async updateUserInfo(
    { email }: Authentication,
    userInfo: UserProfileUpdateQuery,
  ) {
    await this.userRepository.update({ email }, userInfo);
    return plainToInstance(UserProfileUpdateResponse, {});
  }

  async getUserProfile(email: string): Promise<UserProfileResponse> {
    const user = await this.userRepository
      .findOneOrFail({
        where: {
          email,
        },
      })
      .catch((err) => {
        throw new NotFoundException('user not found', {
          cause: err,
          description: 'user not found',
        });
      });
    return plainToInstance(UserProfileResponse, user);
  }

  @Transactional()
  async follow(from: string, to: string) {
    const isFollowed = await this.isUserFollowed(from, to);
    if (!isFollowed) {
      await this.followInternal(from, to);
    } else {
      await this.unfollowInternal(from, to);
    }
    const [followee, follower] = await this.userRepository.find({
      where: { email: In([from, to]) },
      select: ['followersNum', 'followeesNum', 'email'],
    });
    return plainToInstance(UserFollowResponse, {
      followee,
      follower,
    });
  }

  private async followInternal(from: string, to: string) {
    await this.userRepository
      .createQueryBuilder()
      .relation('followees')
      .of(from)
      .add(to)
      .catch((err) => {
        throw new NotFoundException(`user email ${to} not found`, {
          cause: err,
        });
      });
    await this.userRepository.increment({ email: from }, 'followeesNum', 1);
    await this.userRepository.increment({ email: to }, 'followersNum', 1);
  }

  private async unfollowInternal(from: string, to: string) {
    await this.userRepository
      .createQueryBuilder()
      .relation('followees')
      .of(from)
      .remove(to)
      .catch((err) => {
        throw new NotFoundException(`user email ${to} not found`, {
          cause: err,
        });
      });
    await this.userRepository.decrement({ email: from }, 'followeesNum', 1);
    await this.userRepository.decrement({ email: to }, 'followersNum', 1);
  }

  private async isUserFollowed(from: string, to: string) {
    return await this.userRepository.exist({
      where: {
        email: from,
        followees: {
          email: to,
        },
      },
    });
  }

  async getFollowers({
    email,
  }: UserProfileQuery): Promise<UserProfileSimpleResponse[]> {
    return plainToInstance(
      UserProfileSimpleResponse,
      await this.userRepository
        .createQueryBuilder()
        .relation(User, 'followers')
        .of({ email })
        .loadMany(),
    );
  }

  async getFollowees({
    email,
  }: UserProfileQuery): Promise<UserProfileSimpleResponse[]> {
    return plainToInstance(
      UserProfileSimpleResponse,
      await this.userRepository
        .createQueryBuilder()
        .relation(User, 'followees')
        .of({ email })
        .loadMany(),
    );
  }
}
