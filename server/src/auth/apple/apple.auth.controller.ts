import { Body, Controller, Delete, Post } from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AppleClientAuthBody } from './apple.client.auth.body.dto';
import { AppleClientAuthResponse } from './apple.client.auth.response.dto';
import { AppleClientRevokeBody } from './apple.client.revoke.body.dto';
import { AppleAuthService } from './apple.auth.service';
import { Public } from '../auth.decorators';

@ApiTags('Auth/Apple')
@Controller('apple')
export class AppleAuthController {
  constructor(private readonly appleAuthService: AppleAuthService) {}

  @ApiOperation({
    description:
      'Apple 로그인 혹은 회원가입을 실행하여 access token을 반환합니다.',
  })
  @ApiResponse({ type: AppleClientAuthResponse })
  @Public()
  @Post('auth')
  async auth(@Body() payload: AppleClientAuthBody) {
    return await this.appleAuthService.auth(payload);
  }

  @ApiOperation({
    description: 'Apple 회원탈퇴를 진행합니다. 테스트필요',
  })
  @Delete('revoke')
  async revoke(@Body() payload: AppleClientRevokeBody) {
    await this.appleAuthService.revoke(payload);
  }
}
