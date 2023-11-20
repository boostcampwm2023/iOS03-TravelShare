import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/entities/user.entity';
import { Repository } from 'typeorm';
import { AuthBasicSignupBody } from './auth.basic.signup.body.dto';
import { JwtService } from '@nestjs/jwt';
import { Authentication } from './authentication.dto';
import { plainToInstance } from 'class-transformer';
import { hash, genSalt, compare } from 'bcrypt';
import { AuthBasicSigninBody } from './auth.basic.signin.body.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly jwtService: JwtService,
  ) {}

  async createUser(user: AuthBasicSignupBody) {
    const userDetail = await this.userRepository.save({
      ...user,
      password: await hash(user.password, await genSalt()),
    });
    return await this.createAccessToken(
      plainToInstance(Authentication, userDetail),
    );
  }

  async login({ email, password }: AuthBasicSigninBody) {
    const userDetail = await this.userRepository.findOneOrFail({
      where: { email },
      select: ['email', 'password', 'role'],
    });
    if (!(await compare(password, userDetail.password))) {
      throw new BadRequestException('invalid password');
    }
    return await this.createAccessToken(
      plainToInstance(Authentication, userDetail),
    );
  }

  async refreshAccessToken(user: Authentication) {
    return await this.jwtService.signAsync(user);
  }

  private async createAccessToken(user: Authentication) {
    return await this.jwtService.signAsync(user);
  }
}
