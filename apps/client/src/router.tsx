import React from 'react';
import { createBrowserRouter } from 'react-router-dom';
import * as Pages from './view/pages';

export const routes = {
  root: '/',
  main: '/main',
  cart: (id: string | number) => `/cart/${id}`,
};

export const router = createBrowserRouter([
  {
    path: routes.root,
    element: <Pages.Main />,
  },
  {
    path: routes.main,
    element: <Pages.Main />,
  },
  {
    path: routes.cart(':id'),
    element: <Pages.Cart />,
  },
]);
