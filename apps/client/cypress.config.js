const { defineConfig } = require("cypress");

const allureWriter = require('@shelex/cypress-allure-plugin/writer');

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:10000',
    video: true,
    setupNodeEvents(on, config) {
      on('after:spec', (spec, results) => {});
      allureWriter(on, config);
      return config;
    },
    env: {
      allure: true,
      allureLogCypress: false,
      allureAddVideoOnPass: false,
      allureAttachRequests: true,
      allureReuseAfterSpec: true,
    },
  },
});
