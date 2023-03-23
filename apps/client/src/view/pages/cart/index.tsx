import * as React from 'react';
import { FC } from 'react';
import { observer } from 'mobx-react';
import { Hello } from '../../components';
import { Store } from '../../../store';
import './index.less';

export const Cart: FC = observer(() => {
  const { router, hello } = Store.useStore();
  return (
    <Hello
      onClick={() => void router.push('/main')}
      title={`Cart ${hello.counter}`}
      buttonTitle="to main =>"
    />
  );
});
