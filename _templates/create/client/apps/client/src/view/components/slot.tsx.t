---
to: <%= `${h.ROOT}/apps/${h.CLIENT_NAME}/src/view/components/slot.tsx` %>
unless_exists: true
---
import React, { FC, ReactElement } from 'react';

export const Slot: FC<{
  name?: string;
  children?: ReactElement[] | ReactElement | string;
}> = ({ children }) => <>{children}</>;



