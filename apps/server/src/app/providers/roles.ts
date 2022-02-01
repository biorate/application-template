import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators';
import { UserRoles } from '../../enums';
import { AuthorizationNotAuthorizedError } from '../../errors';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  public async canActivate(context: ExecutionContext) {
    const roles = this.reflector.getAllAndOverride<number>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (roles === undefined) return true;
    // const request = context.switchToHttp().getRequest();
    // const { login, sessionId } = request.cookies;
    // if (!login || !sessionId) throw new AuthorizationNotAuthorizedError();
    const user = { role: UserRoles.Basic | UserRoles.Admin }; //TODO: example! get user from db here for role check
    if (!user) throw new AuthorizationNotAuthorizedError();
    return (user.role & roles) === roles;
  }
}
