import { injectable } from '@biorate/inversion';
import { observable, action, makeObservable } from 'mobx';

@injectable()
export class Spinner {
  @observable public visible = false;

  public constructor() {
    makeObservable(this);
  }

  @action show() {
    this.visible = true;
  }

  @action hide() {
    this.visible = false;
  }
}
