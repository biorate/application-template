import './app.less';
import * as React from 'react';
import { upperFirst } from 'lodash';
import { observer } from 'mobx-react';
import { inject, Types } from '@biorate/inversion';
import { Hello as HelloStore, Router } from '../../store';
import * as components from '../components';
import { Blast } from './blast';

@observer
export class App extends React.Component {
  @inject(Types.Hello) protected hello: HelloStore;
  @inject(Types.Router) protected router: Router;

  protected get next() {
    return this.router.mode === 'world' ? 'board' : 'world';
  }

  protected get component() {
    return upperFirst(this.router.mode);
  }

  protected factory() {
    return React.createElement(components[this.component] || components.World);
  }

  public render() {
    return (
      <div className="app">
        <components.Hello /> {this.factory()} {this.hello.world} <Blast />!
        <button onClick={() => this.router.push(`/${this.next}`)}>
          go to "/{this.next}"
        </button>
      </div>
    );
  }
}
