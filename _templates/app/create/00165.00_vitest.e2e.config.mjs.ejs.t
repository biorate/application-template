---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/vitest.e2e.config.mjs`) %>
---
import { defineConfig } from 'vitest/config';
import base from './vitest.base.mjs';

export default defineConfig({
  ...base,
  test: {
    ...base.test,
    include: ['tests/e2e/**/*.e2e.spec.ts'],
    setupFiles: ['reflect-metadata', 'allure-vitest/setup', './tests/e2e/setup.ts'],
    testTimeout: 10_000,
    sequence: { concurrent: false },
    fileParallelism: false,
  },
});
