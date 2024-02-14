import React, { FC } from 'react';
import { observer } from 'mobx-react';
import { Hello } from '../../components';
import { Store } from '../../../store';
import './index.less';

export const Main: FC = observer(() => {
  const { hello } = Store.useStore();
  return (
    <Hello
      onClick={() => void hello.toCart()}
      title={`Main ${hello.counter}`}
      buttonTitle="to cart =>"
    />
  );
});
