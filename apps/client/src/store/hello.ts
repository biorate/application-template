import { injectable } from '@biorate/inversion';
import { Base } from './base';
import { IStore } from '../interfaces';

@injectable()
export class Hello extends Base implements IStore.IHello {
  public world = 0;
}
