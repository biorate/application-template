---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/containers/app/layout.tsx`) %>
unless_exists: true
---
import * as React from 'react';
import { FC, ReactNode } from 'react';
import { observer } from 'mobx-react';

export const Layout: FC<{
  children?: ReactNode;
}> = observer((props) => {
  return <>{props.children}</>;
});
