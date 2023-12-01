import { HttpService } from '@nestjs/axios';
import { ConsoleLogger, Inject, Injectable } from '@nestjs/common';
import { NcpEffectiveLogSearchAnalyticsConfig } from './ncp.elsa.config.dto';

// @Injectable({scope: Scope.TRANSIENT})
@Injectable()
export class NcpEffectiveLogSearchAnalyticsLogger extends ConsoleLogger {
  @Inject()
  private readonly httpService: HttpService;

  @Inject()
  private readonly config: NcpEffectiveLogSearchAnalyticsConfig;

  private sendMessageToElsa(logLevel: any, context: any, message: any) {
    this.httpService
      .request({
        ...this.config.request,
        data: {
          ...this.config.credentials,
          body: message,
          logLevel: logLevel,
          logSource: context,
        },
      })
      .subscribe();
  }

  log(message: any, context?: string): void;
  log(message: any, ...optionalParams: any[]): void;
  log(message: unknown, context?: unknown, ...rest: unknown[]): void {
    this.sendMessageToElsa('log', context, message);
    super.log(message, context, ...rest);
  }

  verbose(message: any, context?: string): void;
  verbose(message: any, ...optionalParams: any[]): void;
  verbose(message: unknown, context?: unknown, ...rest: unknown[]): void {
    this.sendMessageToElsa('verbose', context, message);
    super.verbose(message, context, ...rest);
  }

  warn(message: any, context?: string): void;
  warn(message: any, ...optionalParams: any[]): void;
  warn(message: unknown, context?: unknown, ...rest: unknown[]): void {
    this.sendMessageToElsa('warn', context, message);
    super.warn(message, context, ...rest);
  }

  error(message: any, stackOrContext?: string): void;
  error(message: any, stack?: string, context?: string): void;
  error(message: any, ...optionalParams: any[]): void;
  error(
    message: unknown,
    stack?: unknown,
    context?: unknown,
    ...rest: unknown[]
  ): void {
    this.sendMessageToElsa('error', context, message);
    super.error(message, stack, context, ...rest);
  }
}
