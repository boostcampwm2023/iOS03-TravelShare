import { DynamicModule, Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import configManagerOptionsFactory from './config.manager.options.factory';
import { ConfigManagerRegisterOptions } from './config.manager.register.options';
import { validateOrReject } from 'class-validator';
import { instanceToPlain, plainToInstance } from 'class-transformer';

@Module({
  imports: [ConfigModule.forRoot({ load: [configManagerOptionsFactory], isGlobal: true })],
})
export class ConfigManagerModule {
  static registerAs<T extends Record<string, any>>({schema, path}: ConfigManagerRegisterOptions<T>): DynamicModule {
    return {
      module: ConfigManagerModule,
      providers: [
        {
          inject: [ConfigService],
          provide: schema,
          useFactory: async (configService: ConfigService)=> {
            const config = plainToInstance(schema, configService.get(path));
            await validateOrReject(config, {whitelist: true});
            return instanceToPlain(config);
          }
        }
      ],
      exports: [
        schema
      ]
    }
  }
}

