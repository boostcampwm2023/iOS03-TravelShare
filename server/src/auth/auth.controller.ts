import { Controller, Post, Put } from '@nestjs/common';
import { ApiOperation, ApiResponse, ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { AuthBasicSigninBody } from './auth.basic.signin.body.dto';
import { plainToInstance } from 'class-transformer';
import { AuthBasicAuthResponse } from './auth.basic.auth.response.dto';
import { AuthBasicSignupBody } from './auth.basic.signup.body.dto';
import { AuthenticatedUser, Public } from './auth.decorators';
import { Authentication } from './authentication.dto';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @ApiOperation({
    description:
      '가장 기본이 되는 회원가입 로직입니다. 이메일 비밀 번호 등을 사용합니다.',
  })
  @ApiResponse({ type: AuthBasicAuthResponse })
  @Post('signup')
  @Public()
  async signup(user: AuthBasicSignupBody) {
    return plainToInstance(
      AuthBasicAuthResponse,
      await this.authService.createUser(user),
    );
  }

  @ApiOperation({ description: '이메일 비밀번호를 통해 로그인합니다.' })
  @ApiResponse({ type: AuthBasicAuthResponse })
  @Post('signin')
  @Public()
  async signin(user: AuthBasicSigninBody) {
    return plainToInstance(
      AuthBasicAuthResponse,
      await this.authService.login(user),
    );
  }

  @ApiOperation({
    description: 'Access Token의 만료기한을 갱신하여 응답합니다.',
  })
  @ApiResponse({ type: AuthBasicAuthResponse })
  @Put('refresh')
  async refresh(@AuthenticatedUser() user: Authentication) {
    return plainToInstance(
      AuthBasicAuthResponse,
      await this.authService.refreshAccessToken(user),
    );
  }
}
