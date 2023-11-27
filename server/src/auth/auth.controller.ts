import { Body, Post, Put } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiBody,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { AuthBasicSigninBody } from './auth.basic.signin.body.dto';
import { plainToInstance } from 'class-transformer';
import { AuthBasicAuthResponse } from './auth.basic.auth.response.dto';
import { AuthBasicSignupBody } from './auth.basic.signup.body.dto';
import { AuthenticatedUser, Public } from './auth.decorators';
import { Authentication } from './authentication.dto';
import { RestController } from 'src/utils/rest.controller.decorator';

@ApiTags('Auth')
@RestController('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @ApiOperation({
    description:
      '가장 기본이 되는 회원가입 로직입니다. 이메일 비밀 번호 등을 사용합니다.',
  })
  @ApiResponse({ type: AuthBasicAuthResponse })
  @ApiBody({ type: AuthBasicSignupBody })
  @Post('signup')
  @Public()
  async signup(@Body() user: AuthBasicSignupBody) {
    return plainToInstance(
      AuthBasicAuthResponse,
      await this.authService.createUser(user),
    );
  }

  @ApiOperation({ description: '이메일 비밀번호를 통해 로그인합니다.' })
  @ApiResponse({ type: AuthBasicAuthResponse })
  @ApiBody({ type: AuthBasicSigninBody })
  @Post('signin')
  @Public()
  async signin(@Body() user: AuthBasicSigninBody) {
    return plainToInstance(
      AuthBasicAuthResponse,
      await this.authService.login(user),
    );
  }

  @ApiOperation({
    description: 'Access Token의 만료기한을 갱신하여 응답합니다.',
  })
  @ApiResponse({ type: AuthBasicAuthResponse })
  @ApiBearerAuth('access-token')
  @Put('refresh')
  async refresh(@AuthenticatedUser() { email, role }: Authentication) {
    return plainToInstance(
      AuthBasicAuthResponse,
      await this.authService.refreshAccessToken({
        email,
        role,
      }),
    );
  }
}
