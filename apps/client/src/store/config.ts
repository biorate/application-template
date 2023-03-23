import { init, injectable } from '@biorate/inversion';
import { Config as BaseConfig } from '@biorate/config';

@injectable()
export class Config extends BaseConfig {
  @init() protected initialize() {
    this.set('location.host', process.env.host ?? location.host);
    this.set('location.baseURL', process.env.baseURL ?? location.origin);
  }
}
