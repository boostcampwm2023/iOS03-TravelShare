import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/entities/user.entity';
import { Repository } from 'typeorm';
import { UserSigninBody } from './user.signin.body.dto';
import { UserSignupBody } from './user.signup.body.dto';
import { UserDeleteBody } from './user.delete.body.dto';
import { JwtService } from '@nestjs/jwt';
import { compare, genSalt, hash } from 'bcrypt';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly jwtService: JwtService,
  ) {}

  async save(user: UserSignupBody) {
    const userDetail = await this.userRepository.save({
      ...user,
      password: await hash(user.password, await genSalt()),
    });
    return await this.jwtService.signAsync({
      email: userDetail.email,
      role: userDetail.role,
    });
  }

  async login(user: UserSigninBody) {
    const userDetail = await this.userRepository.findOneOrFail({
      where: { email: user.email },
    });
    if (await compare(user.password, userDetail.password)) {
      return await this.jwtService.signAsync({
        email: userDetail.email,
        role: userDetail.role,
      });
    } else {
      throw new UnauthorizedException('user not found');
    }
  }

  async delete(user: UserDeleteBody) {
    return await this.userRepository.delete({ email: user.email });
  }
}
