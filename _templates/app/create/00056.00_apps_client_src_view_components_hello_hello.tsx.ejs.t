---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/components/hello/hello.tsx`) %>
unless_exists: true
---
import { styled } from 'styled-components';

export const HelloWorld = styled.div<{ size: number }>`
  width: 200px;
  font-size: ${({ size }) => size}px;
`;
