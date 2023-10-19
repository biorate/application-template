import { createContext, useContext } from 'react';
import { init, kill, injectable, inject, Types } from '@biorate/inversion';
import { Config } from './config';
import { Hello } from './hello';
import { Preloader } from './preloader';
import { Spinner } from './spinner';
import { Websocket } from './websocket';

@injectable()
export class Store {
  static StoreContext: React.Context<Store>;

  static useStore: () => Store;

  @inject(Types.Config) public config: Config;

  @inject(Types.Hello) public hello: Hello;

  @inject(Types.Preloader) public preloader: Preloader;

  @inject(Types.Spinner) public spinner: Spinner;

  @inject(Types.Websocket) public websocket: Websocket;

  protected constructor() {
    Store.StoreContext = createContext<Store>(this);
    Store.useStore = () => useContext(Store.StoreContext);
  }

  @init() protected async initialize() {}

  @kill() protected destruct() {}
}

export { Config } from './config';
export { Hello } from './hello';
export { Preloader } from './preloader';
export { Spinner } from './spinner';
export { Websocket } from './websocket';
