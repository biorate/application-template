---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/store/hello.ts`) %>
unless_exists: true
---
import { injectable, init } from '@biorate/inversion';
import { observable, action, makeObservable } from 'mobx';
import { router, routes } from '../router';

@injectable()
export class Hello {
  @observable public counter = 1;

  public id = 1;

  public constructor() {
    makeObservable(this);
  }

  @action protected tick() {
    ++this.counter;
  }

  @action public async toCart() {
    await router.navigate(routes.cart(this.id++));
  }

  @init() protected initialize() {
    setInterval(() => this.tick(), 1000);
  }
}
