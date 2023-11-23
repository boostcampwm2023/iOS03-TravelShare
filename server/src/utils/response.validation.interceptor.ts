import {
  CallHandler,
  ExecutionContext,
  Injectable,
  NestInterceptor,
} from '@nestjs/common';
import { validateOrReject } from 'class-validator';
import { Observable, map } from 'rxjs';

@Injectable()
export class ResponseValidationInterceptor implements NestInterceptor {
  intercept(
    context: ExecutionContext,
    next: CallHandler<any>,
  ): Observable<any> {
    return next.handle().pipe(
      map(async (value) => {
        if (!value || typeof value !== 'object') {
          return value;
        }
        if (Array.isArray(value)) {
          await Promise.all(
            value.map(async (each) => {
              await validateOrReject(each, { whitelist: true });
            }),
          );
        } else {
          await validateOrReject(value, { whitelist: true });
        }
        return value;
      }),
    );
  }
}
