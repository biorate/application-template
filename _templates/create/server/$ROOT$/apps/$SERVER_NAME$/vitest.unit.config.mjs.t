---
mirror: true
---
import { defineConfig } from 'vitest/config';
import base from './vitest.base.mjs';

export default defineConfig({
  ...base,
  test: {
    ...base.test,
    testTimeout: 2_000,
    include: ['tests/unit/**/*.spec.ts'],
    setupFiles: ['reflect-metadata', 'allure-vitest/setup', './tests/unit/setup.ts'],
  },
});
