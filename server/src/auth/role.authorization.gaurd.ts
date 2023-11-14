import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Observable } from 'rxjs';
import { UESR_ROLE_KEY } from './auth.decorators';

@Injectable()
export class RoleAuthorizationGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const requiredRole = this.reflector.getAllAndOverride(UESR_ROLE_KEY, [
      context.getClass(),
      context.getHandler(),
    ]);
    if (!requiredRole) {
      return true;
    }
    const authentication = context.switchToHttp().getRequest().user;
    if (!authentication || requiredRole !== authentication.role) {
      throw new UnauthorizedException('Cannot access');
    }
    return true;
  }
}
