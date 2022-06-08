import { injectable } from '@biorate/inversion';
import { createBrowserHistory } from 'history';
import { RouterStore } from '@superwf/mobx-react-router';

@injectable()
export class Router extends RouterStore {
  public constructor() {
    super(createBrowserHistory());
  }

  public get mode() {
    return this.location.pathname.split('/')?.[1];
  }
}
