import { InternalServerErrorException } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { IsolationLevel } from 'typeorm/driver/types/IsolationLevel';

const { setPrototypeOf } = Object;
const DATA_SOURCE = Symbol('DATA_SOURCE');

/**
 * 함수의 실행이 트렌젝션 스코프 안에서 일어납니다.
 * @deprecated 트렌젝션이 시작될 경우 새로운 커넥션을 연결해버립니다.
 * AsyncLocalStorage 등을 사용하면 해곃할 수 있겠으나, 관련 package가 있어 그로 대체하였습니다.
 * @author jijihuny
 * @param isolationLevel
 */
export const Transactional: (
  isolationLevel?: IsolationLevel,
) => MethodDecorator = (isolationLevel?: IsolationLevel) => {
  return (target: any, property: string, descriptor: PropertyDescriptor) => {
    const originalMethod = descriptor.value;
    const injectDataSourceToTarget = InjectDataSource();
    injectDataSourceToTarget(target, DATA_SOURCE);
    async function newMethod(this: any, ...args: any[]) {
      const queryRunner = (this[DATA_SOURCE] as DataSource).createQueryRunner();
      await queryRunner.connect();
      await queryRunner.startTransaction(isolationLevel);
      try {
        const result = await originalMethod.apply(this, args);
        await queryRunner.commitTransaction();
        return result;
      } catch (err) {
        await queryRunner.rollbackTransaction();
        throw new InternalServerErrorException(err);
      } finally {
        await queryRunner.release();
      }
    }
    setPrototypeOf(newMethod, originalMethod);
    descriptor.value = newMethod;
  };
};
