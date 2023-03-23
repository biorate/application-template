import * as React from 'react';
import { FC } from 'react';
import styles from './index.module.less';

export const Hello: FC<{ onClick: () => void; buttonTitle: string; title: string }> = ({
  onClick,
  buttonTitle,
  title,
}) => {
  return (
    <>
      <div className={styles.hello}>{title}</div>
      <button onClick={onClick}>{buttonTitle}</button>
    </>
  );
};
