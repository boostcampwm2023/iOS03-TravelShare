import {
  ExecutionContext,
  SetMetadata,
  createParamDecorator,
} from '@nestjs/common';

export const PUBLIC_ROUTE_KEY = Symbol('PUBLIC_ROUTE_KEY');
export const Public = () => SetMetadata(PUBLIC_ROUTE_KEY, true);

export const UESR_ROLE_KEY = Symbol('USER_ROLE_KEY');
export const Role = (role: string) => SetMetadata(UESR_ROLE_KEY, role);

export const AuthenticatedUser = createParamDecorator(
  (data: string, context: ExecutionContext) => {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    return data ? user?.[data] : user;
  },
);
