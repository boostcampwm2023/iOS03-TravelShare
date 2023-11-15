import { Module } from '@nestjs/common';
import { AppleAuthController } from './apple.auth.controller';
import { AppleAuthService } from './apple.auth.service';
import { JwtModule } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

@Module({
  imports: [
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) =>
        configService.get('apple.client_secret'),
    }),
  ],
  controllers: [AppleAuthController],
  providers: [AppleAuthService],
})
export class AppleAuthModule {}
