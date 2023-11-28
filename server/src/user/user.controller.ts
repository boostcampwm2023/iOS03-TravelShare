import { Get, Optional, Patch, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
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
import { AuthenticatedUser } from 'auth/auth.decorators';
import { Authentication } from 'auth/authentication.dto';
import { RestController } from 'utils/rest.controller.decorator';
import { UserFollowResponse } from './user.follow.response.dto';

@ApiTags('User')
@ApiBearerAuth('access-token')
@RestController('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @ApiOperation({ description: '회원정보 수정' })
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

  @ApiOperation({ description: '팔로우 혹은 언팔로우' })
  @ApiOkResponse({type: UserFollowResponse})
  @Patch('follow')
  async follow(
    @Query() { followee }: UserFollowQuery,
    @AuthenticatedUser() { email }: Authentication,
  ) {
    return await this.userService.follow(email, followee)
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
