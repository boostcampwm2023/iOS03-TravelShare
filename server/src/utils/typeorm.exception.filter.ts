import {
  Catch,
  ExceptionFilter,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { TypeORMError } from 'typeorm';

@Catch(TypeORMError)
export class TypeOrmExceptionFilter implements ExceptionFilter {
  private readonly logger: Logger = new Logger(TypeOrmExceptionFilter.name);
  catch(exception: any) {
    this.logger.error(exception, exception?.stack);
    throw new InternalServerErrorException('database error occurs');
  }
}
