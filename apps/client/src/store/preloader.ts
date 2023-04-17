import { injectable, init } from '@biorate/inversion';
import { observable, action, makeObservable } from 'mobx';
import { merge } from 'lodash';
import { timer } from '@biorate/tools';

@injectable()
export class Preloader {
  @observable public loaded = false;

  public constructor() {
    makeObservable(this);
  }

  @action protected set(data: Record<string, unknown>) {
    merge(this, data);
  }

  @init() protected async initialize() {
    await timer.wait(1000);
    this.set({ loaded: true });
  }
}
