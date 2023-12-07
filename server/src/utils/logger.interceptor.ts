import {
  CallHandler,
  ExecutionContext,
  Logger,
  NestInterceptor,
} from '@nestjs/common';
import { Request } from 'express';
import { Observable, catchError, tap, throwError } from 'rxjs';

export class LoggerInterceptor implements NestInterceptor {
  private readonly logger: Logger = new Logger(LoggerInterceptor.name);
  intercept(
    context: ExecutionContext,
    next: CallHandler<any>,
  ): Observable<any> | Promise<Observable<any>> {
    const request = context.switchToHttp().getRequest() as Request;
    // request logging
    const { method, url, ip, hostname } = request;
    const handlerName = context.getHandler().name;
    this.logger.debug(
      `request: ${method} ${url} ${ip} ${hostname} arrives to ${handlerName}`,
    );
    const now = Date.now();
    return next.handle().pipe(
      tap((value) => {
        this.logger.debug(`response to ${method} ${url} ${ip} consumes ${
          Date.now() - now
        }ms. response value: ${value}
                            `);
      }),
      catchError((err) => {
        this.logger.error(err);
        return throwError(() => {
          throw err;
        });
      }),
    );
  }
}
