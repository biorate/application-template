import { createContext, useContext } from 'react';
import { init, injectable, inject, Types } from '@biorate/inversion';
import { Hello } from './hello';
import { Router } from './router';

@injectable()
export class Store {
  static StoreContext: React.Context<Store>;

  static useStore: () => Store;

  @inject(Types.Router) public router: Router;

  @inject(Types.Hello) public hello: Hello;

  @init() protected initialize() {
    Store.StoreContext = createContext<Store>(this);
    Store.useStore = () => useContext(Store.StoreContext);
  }
}

export { Hello } from './hello';
export { Router } from './router';
