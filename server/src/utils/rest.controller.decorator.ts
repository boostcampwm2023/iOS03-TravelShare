import {
  Controller,
  ControllerOptions,
  UseInterceptors,
  UsePipes,
  ValidationPipe,
  applyDecorators,
} from '@nestjs/common';
import { ResponseValidationInterceptor } from './response.validation.interceptor';

export function RestController(): ClassDecorator;
export function RestController(prefix: string | string[]): ClassDecorator;
export function RestController(options: ControllerOptions): ClassDecorator;
export function RestController(arg?: any) {
  return applyDecorators(
    Controller(arg),
    UseInterceptors(ResponseValidationInterceptor),
    UsePipes(
      new ValidationPipe({
        transform: true,
        whitelist: true,
        validateCustomDecorators: true,
      }),
    ),
  );
}
