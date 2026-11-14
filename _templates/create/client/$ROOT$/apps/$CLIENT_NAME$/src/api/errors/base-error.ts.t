---
unless_exists: true
mirror: true
---
import { IError } from '../../interfaces';

export abstract class BaseError {
  public abstract process(e: IError): any;
}
