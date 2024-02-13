import * as React from 'react';
import { FC } from 'react';
import { HelloWorld } from './hello';

export const Hello: FC<{ onClick: () => void; buttonTitle: string; title: string }> = ({
  onClick,
  buttonTitle,
  title,
}) => {
  return (
    <>
      <HelloWorld size={20}>{title}</HelloWorld>
      <button data-testid="button" onClick={onClick}>
        {buttonTitle}
      </button>
    </>
  );
};
