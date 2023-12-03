import { ClassConstructor } from 'class-transformer';

export interface ConfigManagerRegisterOptions<T extends Record<string, any>> {
  schema: ClassConstructor<T>;
  path: string;
}
