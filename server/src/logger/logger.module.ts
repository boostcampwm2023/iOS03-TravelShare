import { Module } from '@nestjs/common';
import { NcpEffectiveLogSearchAnalyticsConfigFactory } from './ncp.elsa.logger.config.factory';
import { NcpEffectiveLogSearchAnalyticsLogger } from './ncp.elsa.logger.provider';
import { ConfigService } from '@nestjs/config';
import { NcpEffectiveLogSearchAnalyticsConfig } from './ncp.elsa.config.dto';

@Module({
  providers: [
    {
      inject: [ConfigService],
      provide: NcpEffectiveLogSearchAnalyticsConfig,
      useFactory: NcpEffectiveLogSearchAnalyticsConfigFactory,
    },
    NcpEffectiveLogSearchAnalyticsLogger,
  ],
  exports: [NcpEffectiveLogSearchAnalyticsLogger],
})
export class LoggerModule {}
