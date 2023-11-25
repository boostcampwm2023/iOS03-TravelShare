import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/entities/user.entity';
import { Repository } from 'typeorm';
import { UserProfileUpdateQuery } from './user.profile.update.query.dto';
import { Authentication } from 'src/auth/authentication.dto';
import { UserProfileResponse } from './user.profile.response.dto';
import { plainToInstance } from 'class-transformer';
import { UserProfileQuery } from './user.profile.query.dto';
import { UserProfileSimpleResponse } from './user.profile.simple.response.dto';
import { Transactional } from 'typeorm-transactional';

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
  }

  async getUserProfile(email: string): Promise<UserProfileResponse> {
    const user = await this.userRepository.findOneOrFail({
      where: {
        email,
      },
      relations: {
        writedPosts: true,
      },
    });
    const followersNum = await this.userRepository.countBy({
      followings: { email },
    });
    const followingsNum = await this.userRepository.countBy({
      followers: { email },
    });
    return plainToInstance(UserProfileResponse, {
      ...user,
      followersNum,
      followingsNum,
    });
  }

  @Transactional()
  async follow(from: string, to: string) {
    const isFollowed = await this.userRepository.exist({
      where: {
        followings: {
          email: to,
        },
      },
    });
    if (isFollowed) {
      throw new BadRequestException('already followed');
    }
    await this.userRepository
      .createQueryBuilder()
      .relation('followings')
      .of(from)
      .add(to);
  }

  @Transactional()
  async unfollow(from: string, to: string) {
    const isFollowed = await this.userRepository.exist({
      where: {
        followings: {
          email: to,
        },
      },
    });
    if (!isFollowed) {
      throw new BadRequestException('already unfollowed');
    }
    await this.userRepository
      .createQueryBuilder()
      .relation('followings')
      .of(from)
      .remove(to);
  }

  async getFollowers({
    email,
  }: UserProfileQuery): Promise<UserProfileSimpleResponse[]> {
    return plainToInstance(
      UserProfileSimpleResponse,
      await this.userRepository
        .createQueryBuilder()
        .relation(User, 'followers')
        .of(email)
        .loadMany(),
    );
  }

  async getFollowings({
    email,
  }: UserProfileQuery): Promise<UserProfileSimpleResponse[]> {
    return plainToInstance(
      UserProfileSimpleResponse,
      await this.userRepository
        .createQueryBuilder()
        .relation(User, 'followings')
        .of(email)
        .loadMany(),
    );
  }
}
