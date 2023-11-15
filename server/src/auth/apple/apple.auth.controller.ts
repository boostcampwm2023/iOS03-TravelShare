import { Body, Controller, Post } from '@nestjs/common';
import { ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AppleClientAuthBody } from './apple.client.auth.body.dto';
import { AppleClientAuthResponse } from './apple.client.auth.response.dto';
import { AppleClientRefreshResponse } from './apple.client.refresh.response.dto';
import { AppleClientRefreshBody } from './apple.client.refresh.body.dto';
import { AppleAuthService } from './apple.auth.service';
import { Public } from '../auth.decorators';

@Controller('apple')
export class AppleAuthController {
  constructor(private readonly appleAuthService: AppleAuthService) {}

  @ApiOperation({
    description:
      'Apple 로그인 혹은 회원가입을 실행하여 refresh token과 access token을 반환합니다.',
  })
  @ApiResponse({ type: AppleClientAuthResponse })
  @Public()
  @Post('auth')
  async auth(@Body() payload: AppleClientAuthBody) {
    (await this.appleAuthService.auth(payload)).forEach(console.log);
  }

  @ApiOperation({
    description:
      'Apple 로그인 refresh token을 이용해 새로운 access token을 발급받습니다.',
  })
  @ApiResponse({ type: AppleClientRefreshResponse })
  @Post('refresh')
  async refresh(@Body() payload: AppleClientRefreshBody) {}
}
