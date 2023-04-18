import * as React from 'react';
import { createRoot } from 'react-dom/client';
import { App } from './containers';

export default createRoot(document.getElementById('root')!).render(<App />);
