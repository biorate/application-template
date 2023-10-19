import { IError } from '../types';

export abstract class BaseError {
  public abstract process(e: IError): any;
}
