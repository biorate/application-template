import React, { FC } from 'react';
import { observer } from 'mobx-react';
import { useNavigate } from 'react-router-dom';
import { Hello } from '../../components';
import { Store } from '../../../store';
import './index.less';

export const Cart: FC = observer(() => {
  const { hello } = Store.useStore();
  const navigate = useNavigate();
  return (
    <Hello
      onClick={() => void navigate('/main')}
      title={`Cart ${hello.counter}`}
      buttonTitle="to main =>"
    />
  );
});
