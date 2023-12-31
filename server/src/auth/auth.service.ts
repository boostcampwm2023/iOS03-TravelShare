import {
  ConflictException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'entities/user.entity';
import { Repository } from 'typeorm';
import { AuthBasicSignupBody } from './auth.basic.signup.body.dto';
import { JwtService } from '@nestjs/jwt';
import { Authentication } from './authentication.dto';
import { plainToInstance } from 'class-transformer';
import { hash, genSalt, compare } from 'bcrypt';
import { AuthBasicSigninBody } from './auth.basic.signin.body.dto';
import { getRandomNickName } from 'utils/namemaker';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly jwtService: JwtService,
  ) {}

  async createUser(user: AuthBasicSignupBody) {
    const userDetail = await this.userRepository
      .save({
        ...user,
        ...(user.name ? { name: user.name } : { name: getRandomNickName() }),
        password: await hash(user.password, await genSalt()),
      })
      .catch((err) => {
        throw new ConflictException('user duplicated', { cause: err });
      });
    return await this.createAccessToken(
      plainToInstance(Authentication, userDetail),
    );
  }

  async login({ email, password }: AuthBasicSigninBody) {
    const userDetail = await this.userRepository
      .findOneOrFail({
        where: { email },
        select: ['email', 'password', 'role'],
      })
      .catch((err) => {
        throw new NotFoundException('user not found', { cause: err });
      });
    if (!(await compare(password, userDetail.password))) {
      throw new UnauthorizedException('invalid password');
    }
    return await this.createAccessToken(
      plainToInstance(Authentication, userDetail),
    );
  }

  async refreshAccessToken(user: Authentication) {
    return {
      accessToken: await this.jwtService.signAsync(user),
    };
  }

  async delete(user: Authentication) {
    const userDetail = await this.userRepository
      .findOneByOrFail(user)
      .catch((err) => {
        throw new NotFoundException('user not found', { cause: err });
      });
    await this.userRepository.remove(userDetail);
  }

  private async createAccessToken(user: Authentication) {
    return {
      accessToken: await this.jwtService.signAsync({
        email: user.email,
        role: user.role,
      }),
    };
  }
}
