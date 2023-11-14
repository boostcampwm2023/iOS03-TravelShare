import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PostModule } from './post/post.module';
import { UserModule } from './user/user.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MapModule } from './map/map.module';
import { AppConfigModule } from './config/app.config.module';

@Module({
  imports: [
    PostModule,
    UserModule,
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: 'mysql',
      port: 3306,
      username: 'macro',
      password: 'macro',
      database: 'macro_dev_db',
      migrations: ['dist/**/migrations/*.{js,ts}'],
      entities: ['dist/**/entities/*.entity.{js,ts}'],
      synchronize: true,
      dropSchema: true,
      logging: true,
    }),
    AppConfigModule,
    MapModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
