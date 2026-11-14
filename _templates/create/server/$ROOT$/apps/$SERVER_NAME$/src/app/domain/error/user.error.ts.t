---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { BaseError } from '@biorate/errors';

export class UserAlreadyExistsError extends BaseError {
  public constructor(id: number) {
    super('User already exists [%s]', [id], { status: 409 });
  }
}

export class UserNotExistsError extends BaseError {
  public constructor(id: number) {
    super('User not exists [%s]', [id], { status: 404 });
  }
}
