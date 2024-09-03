---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/errors/base-error.ts`) %>
unless_exists: true
---
import { IError } from '../types';

export abstract class BaseError {
  public abstract process(e: IError): any;
}
