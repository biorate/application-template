---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/package.json`) %>
unless_exists: true
---
{
  "name": "<%= SERVER_NAME %>",
  "version": "0.0.0",
  "description": "<%= APP_DESCRIPTION %> (server application)",
  "main": "dist",
  "scripts": {
    "start": "cross-env LOG_ENABLED=1 LOG_LEVEL=info,error,warn NODE_ENV=production node ./dist/index.js",
    "build": "cross-env NODE_ENV=production npx tsc -p ./tsconfig.build.json --outDir ./dist && tsc-alias -p ./tsconfig.build.json --outDir ./dist",
    "start:debug": "cross-env npx nodemon --exec ts-node -r tsconfig-paths/register index.ts",
    "test": "pnpm run test:all",
    "test:unit": "pnpm exec vitest run -c ./vitest.unit.config.mjs",
    "test:e2e": "cross-env UNIMOCK=replay UNIMOCK_SNAPSHOT_DIR=tests/e2e/__snapshots__ pnpm exec vitest run -c ./vitest.e2e.config.mjs",
    "test:e2e:record": "cross-env UNIMOCK=record UNIMOCK_STRIP_REQUEST=1 UNIMOCK_SKIP_PROXY_ARGS=1 UNIMOCK_GZIP=1 UNIMOCK_SNAPSHOT_DIR=tests/e2e/__snapshots__ pnpm exec vitest run -c ./vitest.e2e.config.mjs",
    "test:all": "pnpm run test:unit && pnpm run test:e2e",
    "migrations": "node -r @biorate/migrations",
    "lint:fix": "npx eslint --fix ./src",
    "prettier:fix": "npx prettier --write ./src",
    "allure:report": "npx allure serve allure-results --clean -o allure-report",
    "hooks:pre-commit": "pnpm run prettier:fix && pnpm run lint:fix"
  },
  "keywords": [],
  "author": "llevkin",
  "license": "UNLICENSED",
  "dependencies": {
    "@biorate/axios-prometheus": "2.2.1",
    "@biorate/config-loader": "2.1.0",
    "@biorate/config-loader-env": "2.1.0",
    "@biorate/config-loader-fs": "2.1.0",
    "@biorate/config-loader-vault": "2.1.0",
    "@biorate/nestjs-tools": "2.2.1",
    "@biorate/prometheus": "3.1.0",
    "@biorate/vault": "2.2.0",
    "@nestjs/common": "10.4.15",
    "@nestjs/core": "10.4.15",
    "@nestjs/event-emitter": "3.0.1",
    "@nestjs/platform-express": "10.4.15",
    <%- ADD_WEB_SOCKET ? '"@nestjs/platform-ws": "10.4.15",' : '' -%>
    "@nestjs/schedule": "6.0.0",
    <%- CLIENT ? '"@nestjs/serve-static": "4.0.2",' : '' -%>
    "@nestjs/swagger": "8.1.0",
    <%- ADD_WEB_SOCKET ? '"@nestjs/websockets": "10.4.15",' : '' -%>
    "class-transformer": "0.5.1",
    "class-validator": "0.14.0",
    "cookie-parser": "1.4.5",
    "express": "4.18.2",
    "helmet": "4.6.0",
    "http-proxy-middleware": "2.0.6",
    <%- ADD_WEB_SOCKET ? '"nestjs-asyncapi": "1.4.0",' : '' -%>
    "@biorate/unimock": "1.8.0",
    "reflect-metadata": "0.2.2",
    "serve-favicon": "2.5.0",
    "source-map-support": "0.5.21",
    "swagger-ui-express": "4.6.2"
    <%- ADD_WEB_SOCKET ? ',"ws": "8.14.2"' : '' -%>
  },
  "devDependencies": {
    "@biorate/migrations": "2.2.2",
    "@biorate/vitest": "2.4.0",
    "@biorate/vitest-spec": "2.2.0",
    "@types/cookie-parser": "1.4.3",
    "@types/express": "4.17.17",
    <%- ADD_WEB_SOCKET ? '"@types/ws": "8.5.8",' : '' -%>
    "nodemon": "3.1.3",
    "supertest": "6.1.6",
    "unplugin-swc": "1.5.3"
  }
}
