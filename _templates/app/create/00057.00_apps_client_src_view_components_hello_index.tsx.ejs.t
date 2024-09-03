---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/components/hello/index.tsx`) %>
unless_exists: true
---
import React, { FC } from 'react';
import { HelloWorld } from './hello';

export const Hello: FC<{ onClick: () => void; buttonTitle: string; title: string }> = ({
  onClick,
  buttonTitle,
  title,
}) => {
  return (
    <>
      <HelloWorld size={20}>{title}</HelloWorld>
      <button onClick={onClick}>{buttonTitle}</button>
    </>
  );
};
