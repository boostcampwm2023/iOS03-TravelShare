import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/entities/user.entity';
import { Repository } from 'typeorm';
import { UserSigninBody } from './user.signin.body.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async login(user: UserSigninBody) {
    const userDetail = await this.userRepository.findOneOrFail({
      where: { userId: user.userId },
    });
    if (userDetail.password === user.password) {
      return true;
    } else {
      return false;
    }
  }
}
