import { BaseError } from './base-error';
import { IError } from '../types';

export class UnknownError extends BaseError {
  public async process(e: IError) {}
}
