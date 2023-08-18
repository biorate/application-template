import { injectable, init } from '@biorate/inversion';
import { observable, action, makeObservable } from 'mobx';
import { router } from '../view/router';

@injectable()
export class Hello {
  @observable public counter = 1;

  public constructor() {
    makeObservable(this);
  }

  @action protected tick() {
    ++this.counter;
  }

  @action public async toCart() {
    await router.navigate('/cart');
  }

  @init() protected initialize() {
    setInterval(() => this.tick(), 1000);
  }
}
