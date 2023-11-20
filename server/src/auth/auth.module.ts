import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { JWT_CREDENTIAL } from './auth.constants';
import { JwtAuthenticationGuard } from './jwt.authentication.gaurd';
import { RoleAuthorizationGuard } from './role.authorization.gaurd';
import { ConfigService } from '@nestjs/config';
import { AppleAuthModule } from './apple/apple.module';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

@Module({
  imports: [AppleAuthModule],
  controllers: [AuthController],
  providers: [
    {
      provide: APP_GUARD,
      useClass: JwtAuthenticationGuard,
    },
    {
      provide: APP_GUARD,
      useClass: RoleAuthorizationGuard,
    },
    {
      provide: JWT_CREDENTIAL,
      inject: [ConfigService],
      useFactory: (configService: ConfigService) =>
        configService.get('application.jwt.secret'),
    },
    AuthService,
  ],
})
export class AuthModule {}
