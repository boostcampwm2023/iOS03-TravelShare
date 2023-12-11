import { Global, Module } from '@nestjs/common';
import { UserBlackListManager } from './user.blacklist.manager';

@Global()
@Module({
  providers: [UserBlackListManager],
})
export class BlackListModule {}
