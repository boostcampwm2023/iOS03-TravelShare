import { Controller, Get, Optional, Patch, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { UserProfileUpdateQuery } from './user.profile.update.query.dto';
import { UserProfileResponse } from './user.profile.response.dto';
import { UserProfileQuery } from './user.profile.query.dto';
import { UserFollowQuery } from './user.follow.query.dto';
import { UserProfileSimpleResponse } from './user.profile.simple.response.dto';
import { UserService } from './user.service';
import { AuthenticatedUser } from 'src/auth/auth.decorators';
import { Authentication } from 'src/auth/authentication.dto';

@ApiTags('User')
@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @ApiOperation({ description: '회원정보 수정' })
  @ApiBearerAuth('access-token')
  @Patch('update')
  async update(
    @AuthenticatedUser() user: Authentication,
    @Query() userInfo: UserProfileUpdateQuery,
  ) {
    await this.userService.updateUserInfo(user, userInfo);
  }

  @ApiResponse({
    description: '나의 정보 혹은 다른 유저의 정보를 불러옵니다.',
    type: UserProfileResponse,
  })
  @ApiBearerAuth('access-token')
  @Get('profile')
  async profile(
    @Optional()
    @Query()
    { email }: UserProfileQuery,
    @AuthenticatedUser()
    user: Authentication,
  ) {
    return this.userService.getUserProfile(email ?? user.email);
  }

  @ApiOperation({ description: '팔로우' })
  @ApiBearerAuth('access-token')
  @Patch('follow')
  async follow(
    @Query() { follower }: UserFollowQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    await this.userService.follow(user.email, follower);
  }

  @ApiOperation({ description: '언팔' })
  @ApiBearerAuth('access-token')
  @Patch('unfollow')
  async unfollow(
    @Query() { follower }: UserFollowQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    await this.userService.unfollow(user.email, follower);
  }

  @ApiOperation({ description: '팔로워 리스트' })
  @ApiQuery({ description: '유저 id', required: false })
  @ApiResponse({ type: [UserProfileSimpleResponse] })
  @Get('followers')
  async followers(
    @Optional() @Query() otherUser: UserProfileQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.userService.getFollowers(otherUser ?? user);
  }

  @ApiOperation({ description: '팔로잉 리스트' })
  @ApiQuery({ description: '유저 id', required: false })
  @ApiResponse({ type: [UserProfileSimpleResponse] })
  @Get('followings')
  async followings(
    @Optional() @Query() otherUser: UserProfileQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.userService.getFollowings(otherUser ?? user);
  }
}
