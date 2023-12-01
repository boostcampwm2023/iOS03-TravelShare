import { ConfigService } from '@nestjs/config';
import { plainToInstance } from 'class-transformer';
import { validateOrReject } from 'class-validator';
import { NcpEffectiveLogSearchAnalyticsConfig } from './ncp.elsa.config.dto';

export const NcpEffectiveLogSearchAnalyticsConfigFactory = async (
  configService: ConfigService,
) => {
  const config = plainToInstance(
    NcpEffectiveLogSearchAnalyticsConfig,
    configService.get('ncp.elsa'),
  );
  await validateOrReject(config);
  return config;
};

export const NCP_ELSA_CONFIG = Symbol('CONFIG');
