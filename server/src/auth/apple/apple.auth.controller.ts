import { Body, Delete, Post } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AppleClientAuthBody } from './apple.client.auth.body.dto';
import { AppleClientAuthResponse } from './apple.client.auth.response.dto';
import { AppleClientRevokeBody } from './apple.client.revoke.body.dto';
import { AppleAuthService } from './apple.auth.service';
import { Public } from '../auth.decorators';
import { RestController } from 'utils/rest.controller.decorator';
import { AppleClientRevokeResponse } from './apple.client.revoke.response';

@ApiTags('Auth/Apple')
@RestController('apple')
export class AppleAuthController {
  constructor(private readonly appleAuthService: AppleAuthService) {}

  @ApiOperation({
    summary: 'Apple 로그인 혹은 회원가입을 실행하여 access token을 반환합니다.',
  })
  @ApiResponse({ type: AppleClientAuthResponse })
  @Public()
  @Post('auth')
  async auth(@Body() payload: AppleClientAuthBody) {
    return await this.appleAuthService.auth(payload);
  }

  @ApiOperation({
    summary: 'Apple 회원탈퇴를 진행합니다. 테스트필요',
  })
  @ApiResponse({ type: AppleClientRevokeResponse })
  @ApiBearerAuth('access-token')
  @Delete('revoke')
  async revoke(@Body() payload: AppleClientRevokeBody) {
    return await this.appleAuthService.revoke(payload);
  }
}
