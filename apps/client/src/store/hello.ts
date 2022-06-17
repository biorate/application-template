import { injectable } from '@biorate/inversion';
import { IStore } from '../interfaces';
import { action, mutation } from './decorators';

@injectable()
export class Hello implements IStore.IHello {
  public world = 0;

  @mutation public inc() {
    ++this.world;
  }

  @action public increment() {
    this.inc();
  }
}
