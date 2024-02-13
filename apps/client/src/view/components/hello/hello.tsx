import { styled } from 'styled-components';

export const HelloWorld = styled.div<{ size: number }>`
  width: 100px;
  font-size: ${({ size }) => size}px;
`;
