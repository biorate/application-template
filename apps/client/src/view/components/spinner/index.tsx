import React, { FC } from 'react';
import styles from './index.module.less';

export const Spinner: FC<{ visible: boolean }> = ({ visible }) => {
  if (!visible) return null;
  return (
    <div className={styles.spinner}>
      <div className={styles.spinner__spin}>Loading...</div>
    </div>
  );
};
