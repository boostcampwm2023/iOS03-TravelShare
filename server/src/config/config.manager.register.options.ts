import { ClassConstructor } from "class-transformer";


export interface ConfigManagerRegisterOptions<T extends Object> {
    schema: ClassConstructor<T>;
    path: string;
}