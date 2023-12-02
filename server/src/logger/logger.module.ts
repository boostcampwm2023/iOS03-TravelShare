import { ConsoleLogger, Module } from '@nestjs/common';
import { NcpEffectiveLogSearchAnalyticsConfigFactory } from './ncp.elsa.logger.config.factory';
import { NcpEffectiveLogSearchAnalyticsLogger } from './ncp.elsa.logger.provider';
import { ConfigService } from '@nestjs/config';
import { NcpEffectiveLogSearchAnalyticsConfig } from './ncp.elsa.config.dto';
import { APPLICATION_LOGGER_SYMBOL } from './app.logger.symbol';

@Module({
  providers: [
    {
      inject: [ConfigService],
      provide: NcpEffectiveLogSearchAnalyticsConfig,
      useFactory: NcpEffectiveLogSearchAnalyticsConfigFactory,
    },
    {
      provide: APPLICATION_LOGGER_SYMBOL,
      useClass:
        process.env.NODE_ENV === 'production'
          ? NcpEffectiveLogSearchAnalyticsLogger
          : ConsoleLogger,
    },
  ],
  exports: [APPLICATION_LOGGER_SYMBOL],
})
export class LoggerModule {}