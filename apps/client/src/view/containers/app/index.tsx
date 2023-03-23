import * as React from 'react';
import { upperFirst } from 'lodash';
import { observer } from 'mobx-react';
import { inject, Types } from '@biorate/inversion';
import { Hello as HelloStore, Router } from '../../../store';
import * as pages from '../../pages';
import './index.less';

@observer
export class App extends React.Component {
  @inject(Types.Hello) protected hello: HelloStore;

  @inject(Types.Router) protected router: Router;

  public render() {
    return <div className="app">{this.factory()}</div>;
  }

  protected factory() {
    return React.createElement(pages[this.page] ?? pages.Main);
  }

  protected get page(): keyof typeof pages {
    return upperFirst(this.router.mode) as unknown as keyof typeof pages;
  }
}
