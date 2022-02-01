import * as React from 'react';
import { render } from 'react-dom';
import { Provider } from 'mobx-react';
import { Router } from 'react-router';
import { init, inject, injectable, Types } from '@biorate/inversion';
import { App } from './containers/app';
import { Store } from '../store';

@injectable()
export class View {
  @inject(Types.Store) protected store: Store;

  protected cloneStore() {
    const store = {};
    for (const field in this.store) store[field] = this.store[field];
    return store;
  }

  @init() protected initialize() {
    render(
      <Provider {...this.cloneStore()}>
        <Router history={this.store.router.history}>
          <App />
        </Router>
      </Provider>,
      document.getElementById('root'),
    );
  }
}
