import * as React from 'react';
import { RouterProvider } from 'react-router-dom';
import { inject, Types } from '@biorate/inversion';
import { observer } from 'mobx-react';
import { Preloader } from '../../../store';
import { Spinner } from '../../components';
import { router } from '../../router';
import './index.less';

@observer
export class App extends React.Component<unknown, unknown> {
  @inject(Types.Preloader) protected preloader: Preloader;

  public render() {
    return !this.preloader.loaded ? (
      <Spinner visible={!this.preloader.loaded} />
    ) : (
      <RouterProvider router={router} />
    );
  }
}
