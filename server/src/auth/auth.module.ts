import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { JwtModule } from '@nestjs/jwt';
import { JWT_CREDENTIAL } from './auth.constants';
import { JwtAuthenticationGuard } from './jwt.authentication.gaurd';
import { RoleAuthorizationGuard } from './role.authorization.gaurd';
import { ConfigService } from '@nestjs/config';

@Module({
  imports: [
    JwtModule.registerAsync({
      global: true,
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        secret: configService.get('jwt.secret'),
        signOptions: {
          expiresIn: configService.get('jwt.expiresIn'),
        },
      }),
    }),
  ],
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
        configService.get('jwt.secret'),
    },
  ],
})
export class AuthModule {}
