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

  @init() protected initialize() {
    render(
      <Router history={this.store.router.history}>
        <App />
      </Router>,
      document.getElementById('root'),
    );
  }
}
