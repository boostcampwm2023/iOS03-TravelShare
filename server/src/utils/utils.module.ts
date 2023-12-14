import { Global, Logger, Module } from '@nestjs/common';
import { HttpModule } from '@nestjs/axios';
import { JwtModule } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DataSource, DataSourceOptions } from 'typeorm';
import { addTransactionalDataSource } from 'typeorm-transactional';
import { KeywordAutoCompleteService } from './keyword.autocomplete.service';
import { RedisModule } from './redis/redis.module';
import { ScheduleModule } from '@nestjs/schedule';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { LoggerInterceptor } from './logger.interceptor';

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
      useFactory: (configService: ConfigService) => ({
        ...configService.get('typeorm'),
        poolErrorHandler: async (err) => {
          Logger.error(err);
          const retryAttempts = 10;
          let attempt = 0;
          const retryDelayMs = 1000;
          setInterval(async () => {
            Logger.log(`Retry Connect ${attempt}`);
            if (attempt < retryAttempts)
              try {
                const dataSource = addTransactionalDataSource(
                  configService.get('typeorm'),
                );
                await dataSource.initialize();
                Logger.log(`Connection success`);
              } catch (err) {
                Logger.log(
                  `Failed to reconnect to database on attempt ${attempt}`,
                );
                attempt++;
              }
          }, retryDelayMs);
        },
      }),
      dataSourceFactory: async (options: DataSourceOptions) =>
        addTransactionalDataSource(new DataSource(options)),
    }),
    RedisModule,
    ScheduleModule.forRoot(),
  ],
  providers: [
    KeywordAutoCompleteService,
    {
      provide: APP_INTERCEPTOR,
      useClass: LoggerInterceptor,
    },
    // {
    //   provide: APP_FILTER,
    //   useClass: TypeOrmExceptionFilter,
    // },
  ],
  exports: [HttpModule, KeywordAutoCompleteService],
})
export class UtilsModule {}
