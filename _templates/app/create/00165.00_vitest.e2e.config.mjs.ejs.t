---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/vitest.e2e.config.mjs`) %>
---
import { defineConfig } from 'vitest/config';
import base from './vitest.base.mjs';

export default defineConfig({
  ...base,
  test: {
    ...base.test,
    testTimeout: 60_000,
    hookTimeout: 120_000,
    pool: 'threads',
    maxWorkers: 1,
    fileParallelism: false,
    isolate: false,
    sequence: { concurrent: false },
    setupFiles: ['reflect-metadata', 'allure-vitest/setup', './tests/e2e/setup.ts'],
    include: ['tests/e2e/**/*.e2e.spec.ts'],
  },
});
