import { Global, Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { JwtModule } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DataSource, DataSourceOptions } from 'typeorm';
import { addTransactionalDataSource } from 'typeorm-transactional';
import { KeywordAutoCompleteService } from './keyword.autocomplete.service';
import { RedisModule } from './redis/redis.module';
import { ScheduleModule } from '@nestjs/schedule';

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
    RedisModule,
    ScheduleModule.forRoot(),
  ],
  providers: [KeywordAutoCompleteService],
  exports: [HttpModule, KeywordAutoCompleteService],
})
export class UtilsModule {}
