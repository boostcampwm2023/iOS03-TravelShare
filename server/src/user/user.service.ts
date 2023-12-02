import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'entities/user.entity';
import { And, Equal, In, Not, Raw, Repository } from 'typeorm';
import { UserProfileUpdateQuery } from './user.profile.update.query.dto';
import { Authentication } from 'auth/authentication.dto';
import { UserProfileResponse } from './user.profile.response.dto';
import { plainToInstance } from 'class-transformer';
import { UserProfileQuery } from './user.profile.query.dto';
import { Transactional } from 'typeorm-transactional';
import { UserProfileUpdateResponse } from './user.profile.update.response.dto';
import { UserFollowResponse } from './user.follow.response.dto';
import { UserSearchQuery } from './user.search.query.dto';
import { UserSearchResponse } from './user.search.response.dto';

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
    // TODO 검색어 자동완성에서 기존 닉네임 삭제 새로운 닉네임 추가
    await this.userRepository.update({ email }, userInfo);
    return plainToInstance(UserProfileUpdateResponse, {});
  }

  async getUserProfile(
    { email }: UserProfileQuery,
    loginUser: Authentication,
  ): Promise<UserProfileResponse> {
    const user = await this.userRepository
      .findOneOrFail({
        where: {
          email: email ?? loginUser.email,
        },
      })
      .catch((err) => {
        throw new NotFoundException('user not found', {
          cause: err,
          description: 'user not found',
        });
      });
    return plainToInstance(UserProfileResponse, {
      ...user,
      follower: email
        ? await this.userRepository.exist({
            where: {
              email: loginUser.email,
              followers: { email },
            },
          })
        : undefined,
      followee: email
        ? await this.userRepository.exist({
            where: {
              email: loginUser.email,
              followees: { email },
            },
          })
        : undefined,
    });
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
      lock: {
        mode: 'pessimistic_write',
      },
    });
  }

  async getFollowers({
    email,
  }: UserProfileQuery): Promise<UserProfileResponse[]> {
    return plainToInstance(
      UserProfileResponse,
      await this.userRepository
        .createQueryBuilder()
        .relation(User, 'followers')
        .of({ email })
        .loadMany(),
    );
  }

  async getFollowees({
    email,
  }: UserProfileQuery): Promise<UserProfileResponse[]> {
    return plainToInstance(
      UserProfileResponse,
      await this.userRepository
        .createQueryBuilder()
        .relation(User, 'followees')
        .of({ email })
        .loadMany(),
    );
  }

  async search(
    { email, name, ...pagination }: UserSearchQuery,
    loginUser: Authentication,
  ) {
    const users = await this.userRepository.find({
      where: [
        {
          ...(email
            ? {
                email: And(Equal(email), Not(Equal(loginUser.email))),
              }
            : {}),
        },
        {
          ...(name
            ? {
                email: Not(loginUser.email),
                name: Raw((alias) => `MATCH(${alias}) AGAINST(:name)`, {
                  name,
                }),
              }
            : {}),
        },
      ],
      ...pagination,
    });

    const userEmails = users.map(({ email }) => email);
    const followees = (
      await this.userRepository.find({
        where: {
          email: In(userEmails),
          followers: {
            email: loginUser.email,
          },
        },
        select: { email: true },
      })
    ).map(({ email }) => email);
    const followers = (
      await this.userRepository.find({
        where: {
          email: In(userEmails),
          followees: {
            email: loginUser.email,
          },
        },
        select: { email: true },
      })
    ).map(({ email }) => email);

    return plainToInstance(
      UserSearchResponse,
      users.map((user) => ({
        ...user,
        follower: followers.includes(user.email),
        followee: followees.includes(user.email),
      })),
    );
  }
}
