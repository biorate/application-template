import { injectable } from '@biorate/inversion';
import { IStore } from '../interfaces';
import { Mutation } from './decorators';

@injectable()
export class Hello implements IStore.IHello {
  public world = 0;

  public increment() {
    ++this.world;
  }
}
