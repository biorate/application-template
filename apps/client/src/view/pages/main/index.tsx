import * as React from 'react';
import { FC } from 'react';
import { observer } from 'mobx-react';
import { Hello } from '../../components';
import { Store } from '../../../store';
import './index.less';

export const Main: FC = observer(() => {
  const { router, hello } = Store.useStore();
  return (
    <Hello
      onClick={() => void router.push('/cart')}
      title={`Main ${hello.counter}`}
      buttonTitle="to cart =>"
    />
  );
});
