---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/vitest.base.mjs`) %>
---
import swc from 'unplugin-swc';
import { defineConfig } from 'vitest/config';
import path from 'node:path';

export default defineConfig({
  esbuild: false,
  plugins: [
    swc.vite({
      sourceMaps: true,
      jsc: {
        parser: {
          syntax: 'typescript',
          decorators: true,
          dynamicImport: true,
        },
        transform: {
          legacyDecorator: true,
          decoratorMetadata: true,
          useDefineForClassFields: false,
        },
        target: 'es2022',
      },
      module: {
        type: 'es6',
      },
    }),
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'),
    },
  },
  test: {
    globals: true,
    exclude: ['node_modules', 'dist'],
    reporters: ['default', ['allure-vitest/reporter', { resultsDir: 'allure-results' }]],
  },
});
