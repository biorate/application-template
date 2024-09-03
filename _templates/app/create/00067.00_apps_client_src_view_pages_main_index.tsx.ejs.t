---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/pages/main/index.tsx`) %>
unless_exists: true
---
import * as React from 'react';
import { FC } from 'react';
import { observer } from 'mobx-react';
import { t } from '@biorate/i18n';
import { useNavigate } from 'react-router-dom';
import { Hello } from '../../components';
import { Store } from '../../../store';
import './index.less';

export const Main: FC = observer(() => {
  const { hello, i18n } = Store.useStore();
  const navigate = useNavigate();
  return (
    <>
      <Hello
        onClick={() => hello.toCart()}
        title={`${t`Привет мир`} Main ${hello.counter} ${i18n.language}`}
        buttonTitle="to cart =>"
      />
      <div style={{ marginTop: 5 }}>
        {i18n.languages.map((lang) => (
          <button
            style={{ marginRight: 5 }}
            key={lang}
            onClick={() => i18n.changeLanguage(lang)}
          >
            {lang}
          </button>
        ))}
      </div>
    </>
  );
});
