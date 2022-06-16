import { injectable, init } from '@biorate/inversion';
import { IStore } from '../interfaces';

@injectable()
export class Hello implements IStore.IHello {
  public world = 0;
}
