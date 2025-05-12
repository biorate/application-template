---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/src/errors/authorize.ts`) %>
unless_exists: true
---
import { BaseError } from '@biorate/errors';

export class AuthorizationIncorrectLoginError extends BaseError {
  public constructor() {
    super('Incorrect login or password', undefined, { status: 401 });
  }
}

export class AuthorizationNotAuthorizedError extends BaseError {
  public constructor() {
    super('Not authorized', undefined, { status: 401 });
  }
}
