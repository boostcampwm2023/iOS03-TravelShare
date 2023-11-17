import { Module } from '@nestjs/common';
import { AppleAuthController } from './apple.auth.controller';
import { AppleAuthService } from './apple.auth.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppleAuth } from 'src/entities/apple.auth.entity';
import { User } from 'src/entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([AppleAuth, User])],
  controllers: [AppleAuthController],
  providers: [AppleAuthService],
})
export class AppleAuthModule {}
