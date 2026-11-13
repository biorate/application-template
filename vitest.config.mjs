import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    include: ['tests/**/*.{test,spec}.{js,ts,mjs}'],
    globals: true,
    setupFiles: ['reflect-metadata', 'allure-vitest/setup'],
    testTimeout: 60000,
    watch: false,
    reporters: [
      'default',
      ['allure-vitest/reporter', { resultsDir: 'allure-results', suiteTitle: false }],
    ],
  },
});
