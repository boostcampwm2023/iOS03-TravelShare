import { Global, Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { JwtModule } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DataSource, DataSourceOptions } from 'typeorm';
import { addTransactionalDataSource } from 'typeorm-transactional';
import { AutoCompleteService } from './autocomplete.service';
import { Post } from 'src/entities/post.entity';

@Global()
@Module({
  imports: [
    HttpModule.register({
      timeout: 5000,
    }),
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) =>
        configService.get('application.jwt'),
      global: true,
    }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) =>
        configService.get('typeorm'),
      dataSourceFactory: async (options: DataSourceOptions) =>
        addTransactionalDataSource(new DataSource(options)),
    }),
    TypeOrmModule.forFeature([Post]),
  ],
  providers: [AutoCompleteService],
  exports: [HttpModule, AutoCompleteService],
})
export class UtilsModule {}
