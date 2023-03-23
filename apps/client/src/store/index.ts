import { createContext, useContext } from 'react';
import { init, injectable, inject, Types } from '@biorate/inversion';
import { Config } from './config';
import { Hello } from './hello';
import { Router } from './router';
import { Websocket } from './websocket';

@injectable()
export class Store {
  static StoreContext: React.Context<Store>;

  static useStore: () => Store;

  @inject(Types.Config) public config: Config;

  @inject(Types.Router) public router: Router;

  @inject(Types.Hello) public hello: Hello;

  @inject(Types.Websocket) public websocket: Websocket;

  @init() protected initialize() {
    Store.StoreContext = createContext<Store>(this);
    Store.useStore = () => useContext(Store.StoreContext);
  }
}

export { Config } from './config';
export { Hello } from './hello';
export { Router } from './router';
export { Websocket } from './websocket';
