import { Get, Optional, Patch, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { UserProfileUpdateQuery } from './user.profile.update.query.dto';
import { UserProfileResponse } from './user.profile.response.dto';
import { UserProfileQuery } from './user.profile.query.dto';
import { UserFollowQuery } from './user.follow.query.dto';
import { UserService } from './user.service';
import { AuthenticatedUser } from 'auth/auth.decorators';
import { Authentication } from 'auth/authentication.dto';
import { RestController } from 'utils/rest.controller.decorator';
import { UserFollowResponse } from './user.follow.response.dto';
import { UserProfileUpdateResponse } from './user.profile.update.response.dto';
import { UserSearchQuery } from './user.search.query.dto';
import { UserSearchResponse } from './user.search.response.dto';
import { UserFollowersQuery } from './user.followers.query.dto';
import { UserFollowersResponse } from './user.followers.response.dto';
import { UserFolloweesQuery } from './user.followees.query.dto';
import { UserFolloweesResponse } from './user.followees.response.dto';

@ApiTags('User')
@ApiBearerAuth('access-token')
@RestController('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @ApiOperation({
    summary: '유저 정보를 업데이트합니다.',
    description: `
# user/update

- 유저 정보를 업데이트합니다.
- 쿼리 파라미터로 name, introduce(자기소개), imageUrl(프로필 사진) 중 하나 이상을 설정할 수 있습니다.
- 응답 포맷은 email과 함께 수정 완료된 정보를 응답합니다.
`,
  })
  @ApiOkResponse({ type: UserProfileUpdateResponse })
  @Patch('update')
  async update(
    @AuthenticatedUser() user: Authentication,
    @Query() userInfo: UserProfileUpdateQuery,
  ) {
    return await this.userService.updateUserInfo(user, userInfo);
  }

  @ApiOperation({
    summary: '나의 정보 혹은 다른 유저의 정보를 불러옵니다.',
    description: `
# user/profile

- 유저 정보를 불러옵니다.
- 자기 자신일 경우 팔로우 관련(follower, followee) 정보를 제공하지 않습니다.
    
    `,
  })
  @ApiResponse({
    type: UserProfileResponse,
  })
  @Get('profile')
  async profile(
    @Optional()
    @Query()
    user: UserProfileQuery,
    @AuthenticatedUser()
    owner: Authentication,
  ) {
    return await this.userService.getUserProfile(user, owner);
  }

  @ApiOperation({ summary: '팔로우 혹은 언팔로우' })
  @ApiOkResponse({ type: UserFollowResponse })
  @Patch('follow')
  async follow(
    @Query() { followee }: UserFollowQuery,
    @AuthenticatedUser() { email }: Authentication,
  ) {
    return await this.userService.follow(email, followee);
  }

  @ApiOperation({ summary: '팔로워 리스트' })
  @ApiResponse({ type: [UserFollowersResponse] })
  @Get('followers')
  async followers(
    @Optional() @Query() otherUser: UserFollowersQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.userService.getFollowers({ ...user, ...otherUser });
  }

  @ApiOperation({ summary: '팔로잉 리스트' })
  @ApiResponse({ type: [UserFolloweesResponse] })
  @Get('followees')
  async followings(
    @Optional() @Query() otherUser: UserFolloweesQuery,
    @AuthenticatedUser() user: Authentication,
  ) {
    return await this.userService.getFollowees({ ...user, ...otherUser });
  }

  @ApiOperation({
    summary: '유저 검색',
    description: `
# user/search

- 유저를 검색합니다.
- 이메일 혹은 닉네임을 통해 검색합니다.
- 검색결과로 본인은 제외되며, 팔로우 여부와 숫자 등 정보를 제공합니다.

    `,
  })
  @ApiResponse({ type: UserSearchResponse })
  @Get('search')
  async search(
    @Query() query: UserSearchQuery,
    @AuthenticatedUser() loginUser: Authentication,
  ) {
    return await this.userService.search(query, loginUser);
  }
}
