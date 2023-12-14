import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PostModule } from './post/post.module';
import { UserModule } from './user/user.module';
import { MapModule } from './map/map.module';
import { AuthModule } from './auth/auth.module';
import { UtilsModule } from './utils/utils.module';
import { FileModule } from './file/file.module';
import { RouteModule } from './route/route.module';
import { LoggerModule } from 'logger/logger.module';
import { SentimentModule } from 'sentiment/sentiment.module';
import { ConfigManagerModule } from 'config/config.manager.module';
import { ReportModule } from 'report/report.module';

@Module({
  imports: [
    PostModule,
    UserModule,
    ConfigManagerModule,
    MapModule,
    RouteModule,
    AuthModule,
    UtilsModule,
    FileModule,
    LoggerModule,
    SentimentModule,
    ReportModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
