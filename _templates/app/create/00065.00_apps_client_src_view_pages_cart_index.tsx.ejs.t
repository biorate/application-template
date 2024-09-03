---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/pages/cart/index.tsx`) %>
unless_exists: true
---
import * as React from 'react';
import { FC } from 'react';
import { observer } from 'mobx-react';
import { useNavigate, useParams } from 'react-router-dom';
import { t } from '@biorate/i18n';
import { routes } from '../../../router';

import { Hello } from '../../components';
import { Store } from '../../../store';
import './index.less';

export const Cart: FC = observer(() => {
  const { hello } = Store.useStore();
  const { id } = useParams();
  const navigate = useNavigate();
  return (
    <Hello
      onClick={() => void navigate(routes.main)}
      title={`${t`Привет мир`} Cart-${id} ${hello.counter}`}
      buttonTitle="to main =>"
    />
  );
});
