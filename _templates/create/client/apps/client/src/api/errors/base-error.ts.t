---
to: <%= `${h.ROOT}/apps/${h.CLIENT_NAME}/src/api/errors/base-error.ts` %>
unless_exists: true
---
import { IError } from '../../interfaces';

export abstract class BaseError {
  public abstract process(e: IError): any;
}
