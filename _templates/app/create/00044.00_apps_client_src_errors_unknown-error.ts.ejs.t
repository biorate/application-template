---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/errors/unknown-error.ts`) %>
unless_exists: true
---
import { BaseError } from './base-error';
import { IError } from '../types';

export class UnknownError extends BaseError {
  public async process(e: IError) {}
}
