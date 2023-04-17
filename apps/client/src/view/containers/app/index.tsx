import * as React from 'react';
import { upperFirst } from 'lodash';
import { observer } from 'mobx-react';
import { inject, Types } from '@biorate/inversion';
import { Hello as HelloStore, Router as RouterStore, Preloader } from '../../../store';
import * as pages from '../../pages';
import { Spinner } from '../../components';
import './index.less';

@observer
export class App extends React.Component {
  @inject(Types.Hello) protected hello: HelloStore;

  @inject(Types.Router) protected router: RouterStore;

  @inject(Types.Preloader) protected preloader: Preloader;

  public render() {
    return <div className="app">{this.factory()}</div>;
  }

  protected factory() {
    return this.preloader.loaded ? (
      React.createElement(pages[this.page] ?? pages.Main)
    ) : (
      <Spinner visible={!this.preloader.loaded} />
    );
  }

  protected get page(): keyof typeof pages {
    return upperFirst(this.router.mode) as unknown as keyof typeof pages;
  }
}
