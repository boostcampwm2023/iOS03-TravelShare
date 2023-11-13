import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PostModule } from './post/post.module';
import { UserModule } from './user/user.module';
import { TypeOrmModule } from '@nestjs/typeorm';

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
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
