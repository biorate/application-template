import * as React from 'react';
import { inject, observer } from 'mobx-react';

export const Blast = inject('hello')(
  observer((store) => {
    return <span>{store.hello.blast}</span>;
  }),
);
