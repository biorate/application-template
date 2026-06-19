---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/vitest.unit.config.mjs`) %>
---
import { defineConfig } from 'vitest/config';
import base from './vitest.base.mjs';

export default defineConfig({
  ...base,
  test: {
    ...base.test,
    include: ['tests/unit/**/*.spec.ts'],
    setupFiles: ['reflect-metadata', 'allure-vitest/setup', './tests/unit/setup.ts'],
    testTimeout: 2_000,
  },
});
