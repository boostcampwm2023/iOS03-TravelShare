import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PostModule } from './post/post.module';
import { UserModule } from './user/user.module';
import { MapModule } from './map/map.module';
import { AppConfigModule } from './config/app.config.module';
import { AuthModule } from './auth/auth.module';
import { UtilsModule } from './utils/utils.module';
import { FileModule } from './file/file.module';
import { RouteModule } from './route/route.module';
import { LoggerModule } from 'logger/logger.module';

@Module({
  imports: [
    PostModule,
    UserModule,
    AppConfigModule,
    MapModule,
    RouteModule,
    AuthModule,
    UtilsModule,
    FileModule,
    LoggerModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
