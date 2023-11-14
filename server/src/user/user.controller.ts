import {
  Body,
  Controller,
  Delete,
  Get,
  Optional,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
  ApiResponse,
} from '@nestjs/swagger';
import { UserSigninResponse } from './user.signin.response.dto';
import { UserSignupBody } from './user.signup.body.dto';
import { UserSigninBody } from './user.signin.body.dto';
import { UserProfileUpdateQuery } from './user.profile.update.query.dto';
import { UserProfileResponse } from './user.profile.response.dto';
import { UserProfileQuery } from './user.profile.query.dto';
import { UserFollowQuery } from './user.follow.query.dto';
import { UserProfileSimpleResponse } from './user.profile.simple.response.dto';
import { UserService } from './user.service';
import { UserDeleteBody } from './user.delete.body.dto';
import { Public } from 'src/auth/auth.decorators';
import { plainToInstance } from 'class-transformer';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @ApiOperation({ description: '회원가입' })
  @ApiResponse({ type: UserSigninResponse })
  @Public()
  @Post('signup')
  async signup(@Body() user: UserSignupBody) {
    return plainToInstance(UserSigninResponse, {
      token: await this.userService.signup(user),
    });
  }

  @ApiOperation({ description: '기본 로그인' })
  @ApiResponse({ type: UserSigninResponse })
  @Public()
  @Post('signin')
  async signin(@Body() user: UserSigninBody) {
    return plainToInstance(UserSigninResponse, {
      token: await this.userService.login(user),
    });
  }

  @ApiOperation({ description: '로그아웃' })
  @ApiBearerAuth('access-token')
  @Post('signout')
  async signout() {}

  @ApiOperation({ description: '회원탈퇴' })
  @ApiBearerAuth('access-token')
  @Delete('delete')
  async delete(@Body() user: UserDeleteBody) {
    return await this.userService.delete(user);
  }

  @ApiOperation({ description: '회원정보 수정' })
  @ApiBearerAuth('access-token')
  @Patch('update')
  async update(@Query() user: UserProfileUpdateQuery) {}

  @ApiResponse({
    description: '나의 정보 혹은 다른 유저의 정보를 불러옵니다.',
    type: UserProfileResponse,
  })
  @ApiBearerAuth('access-token')
  @Get('profile')
  async profile(
    @Optional()
    @Query()
    query: UserProfileQuery,
  ) {}

  @ApiOperation({ description: '팔로우' })
  @ApiBearerAuth('access-token')
  @Patch('follow')
  async follow(@Query() follower: UserFollowQuery) {}

  @ApiOperation({ description: '언팔' })
  @ApiBearerAuth('access-token')
  @Patch('unfollow')
  async unfollow(@Query() follower: UserFollowQuery) {}

  @ApiOperation({ description: '팔로워 리스트' })
  @ApiQuery({ description: '유저 id', required: false })
  @ApiResponse({ type: [UserProfileSimpleResponse] })
  @Get('followers')
  async followers(@Query() user: UserProfileQuery) {}

  @ApiOperation({ description: '팔로잉 리스트' })
  @ApiQuery({ description: '유저 id', required: false })
  @ApiResponse({ type: [UserProfileSimpleResponse] })
  @Get('followings')
  async followings(@Query() user: UserProfileQuery) {}
}
