import {
  CanActivate,
  ExecutionContext,
  Inject,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';
import { Request } from 'express';

import { JWT_CREDENTIAL } from './auth.constants';
import { PUBLIC_ROUTE_KEY } from './auth.decorators';

@Injectable()
export class JwtAuthenticationGuard implements CanActivate {
  constructor(
    private readonly jwtService: JwtService,
    private readonly reflector: Reflector,
    @Inject(JWT_CREDENTIAL) private readonly secret: string,
  ) {}

  async canActivate(context: ExecutionContext) {
    const isPublic = this.reflector.getAllAndOverride(PUBLIC_ROUTE_KEY, [
      context.getClass(),
      context.getHandler(),
    ]);
    if (isPublic) {
      return true;
    }
    const request = context.switchToHttp().getRequest() as Request;
    const token = this.extract(request);
    if (!token) {
      throw new UnauthorizedException(`Jwt Token Not Provided`);
    }
    try {
      const payload = await this.jwtService.verifyAsync(token, {
        secret: this.secret,
      });
      request['user'] = payload;
    } catch (err) {
      throw new UnauthorizedException('Failed to verify jwt token');
    }
    return true;
  }

  /**
   * 헤더로부터 Jwt Token을 추출합니다.
   * @param request
   * @returns
   */
  private extract(request: Request) {
    const [type, token] = request.headers.authorization?.split(/\s+/) ?? [];
    return type === 'Bearer' ? token : undefined;
  }
}
