import { injectable, init } from '@biorate/inversion';
import { observable, makeObservable } from 'mobx';

@injectable()
export class Hello {
  @observable public blast = 1;
  @observable public world = 0;

  public constructor() {
    makeObservable(this);
  }

  @init() protected initialize() {
    setInterval(() => ++this.world, 1000);
    setInterval(() => ++this.blast, 1000);
  }
}
