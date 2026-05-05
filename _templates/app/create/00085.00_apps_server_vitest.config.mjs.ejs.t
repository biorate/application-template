---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/vitest.config.mjs`) %>
unless_exists: true
---
import { defineConfig } from 'vitest/config';
import { fileURLToPath } from 'node:url';
import swc from 'unplugin-swc';

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
    alias: [
      {
        find: /^@\/(.*)$/,
        replacement: fileURLToPath(new URL('./src/$1', import.meta.url)),
      },
    ],
  },
  test: {
    globals: true,
    testTimeout: 2000,
    hookTimeout: 30000,
    setupFiles: ['reflect-metadata', './tests/setup.ts'],
    reporters: [
      'default',
      ['allure-vitest/reporter', { resultsDir: 'allure-results', suiteTitle: false }],
    ],
    exclude: ['node_modules', 'dist'],
  },
});

