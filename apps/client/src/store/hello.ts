import { injectable, init } from '@biorate/inversion';
import { observable, action, makeObservable } from 'mobx';

@injectable()
export class Hello {
  @observable public counter = 1;

  public constructor() {
    makeObservable(this);
  }

  @action protected tick() {
    ++this.counter;
  }

  @init() protected initialize() {
    setInterval(() => this.tick(), 1000);
  }
}
