import { Axios, IAxiosFetchOptions } from '@biorate/axios';
import { UnknownError } from '../errors';
import { IError } from '../interfaces';
import * as errors from '../errors';

export class BaseApi extends Axios {
  public withCredentials = true;
  public baseURL = process.env.API_URL || location.origin;

  protected async before(params: IAxiosFetchOptions) {
    await super.before(params);
  }

  protected async finally() {
    await super.finally();
  }

  protected async catch(e: IError) {
    const Error = errors[e?.response?.data?.code];
    await (Error ? new Error().process(e) : new UnknownError().process(e));
    await super.catch(e);
  }
}
