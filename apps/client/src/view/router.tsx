import React from 'react';
import { createBrowserRouter } from 'react-router-dom';
import * as pages from './pages';

export const router = createBrowserRouter([
  {
    path: '/',
    element: <pages.Main />,
  },
  {
    path: '/main',
    element: <pages.Main />,
  },
  {
    path: '/cart',
    element: <pages.Cart />,
  },
]);
