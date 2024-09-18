---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/pages/bar/index.tsx`) %>
unless_exists: true
---
import * as React from 'react';
import { FC } from 'react';
import { observer } from 'mobx-react';
import { t } from '@biorate/i18n';
import { Hello } from '../../components';
import { Store } from '../../../store';
import './index.less';

export const Bar: FC = observer(() => {
  const { hello, i18n } = Store.useStore();
  return (
    <div className="center">
      <Hello
        i18n={i18n}
        onClick={() => hello.toFoo()}
        title={`${t`Привет мир`} (${i18n.language}) Bar-${hello.counter}-${hello.id}`}
        buttonTitle="foo"
      />
    </div>
  );
});

