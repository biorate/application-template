---
force: true
mirror: true
---
{
  "name": "<%= h.APP_NAME %>",
  "private": true,
  "version": "0.0.0",
  "description": "<%= h.APP_DESCRIPTION %>",
  "keywords": [],
  "author": "llevkin",
  "license": "UNLICENSED",
  "scripts": {
    "build": "npx lerna run build --stream --no-prefix --scope <%= h.CLIENT_NAME %> --scope <%= h.SERVER_NAME %>",
    "start": "pnpm --prefix apps/<%= h.SERVER_NAME %> start",
    "build:debug": "npx lerna run build:debug --stream --no-prefix --scope <%= h.CLIENT_NAME %>",
    "start:debug": "npx lerna run start:debug --stream --no-prefix --scope <%= h.SERVER_NAME %>",
    "test": "npx lerna run test --stream --no-prefix --scope <%= h.SERVER_NAME %> --scope <%= h.CLIENT_NAME %>",
    "migrations": "npx lerna run migrations --stream --no-prefix --scope <%= h.SERVER_NAME %>",
    "test:server": "npx lerna run test --stream --no-prefix --scope <%= h.SERVER_NAME %>",
    "test:client": "npx lerna run test --stream --no-prefix --scope <%= h.CLIENT_NAME %>",
    "version": "npx lerna version",
    "cleanup:node_modules": "cleanup '**/node_modules'",
    "cleanup": "pnpm run cleanup:node_modules './{packages,apps}/**/{dist,coverage,allure-results}'",
    "update": "pnpm up '@biorate/*' --latest --filter '*' && pnpm run reinstall",
    "reinstall": "pnpm run cleanup './pnpm-lock.yaml' && pnpm i",
    "prepare": "npx husky install",
    "allure:report": "npx lerna run allure:report --scope <%= h.SERVER_NAME %> --scope <%= h.CLIENT_NAME %>",
    "hooks:pre-commit": "npx lerna run hooks:pre-commit --scope <%= h.SERVER_NAME %> --scope <%= h.CLIENT_NAME %>",
    "ls-lint": "npx ls-lint"
  },
  "engines": {
    "yarn": ">=1.22.22",
    "pnpm": ">=9.7.1",
    "npm": ">=10.8.2",
    "node": ">=20"
  },
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "resolutions": {
    "mem": "4.0.0",
    "got": "11.8.5",
    "deep-extend": "0.5.1",
    <%- h.CLIENT ? '"postcss": "8.4.31",' : '' %>
    "json5": "1.0.2",
    <%- h.CLIENT ? '"pug": "3.0.1",' : '' %>
    "loader-utils": "1.4.2",
    "semver": "7.5.2"
    <%- h.CLIENT ? ',"styled-components": "6.1.8"' : '' %>
  },
  "overrides": {
    "mem": "4.0.0",
    "got": "11.8.5",
    "deep-extend": "0.5.1",
    <%- h.CLIENT ? '"postcss": "8.4.31",' : '' %>
    "json5": "1.0.2",
    <%- h.CLIENT ? '"pug": "3.0.1",' : '' %>
    "loader-utils": "1.4.2",
    "semver": "7.5.2"
    <%- h.CLIENT ? ',"styled-components": "6.1.8"' : '' %>
  },
  "devDependencies": {
    "@atao60/fse-cli": "0.1.9",
    "@biorate/cleanup": "2.2.5",
    "@ls-lint/ls-lint": "2.2.3",
    "@biorate/vitest": "2.4.6",
    "@biorate/vitest-spec": "2.2.6",
    "@types/flat": "5.0.2",
    "@types/lodash": "4.14.170",
    "@types/minimist": "1.2.5",
    "@types/node": "24.10.12",
    "@types/qs": "6.9.18",
    "@types/traverse": "0.6.32",
    "@typescript-eslint/eslint-plugin": "5.37.0",
    "@typescript-eslint/parser": "5.00.0",
    "allure-commandline": "2.25.0",
    "allure-js-commons": "3.2.0",
    "allure-vitest": "3.7.1",
    "cookies": "0.8.0",
    <%- h.CLIENT ? '"css-loader": "5.2.6",' : '' %>
    <%- h.CLIENT ? '"css-minimizer-webpack-plugin": "3.0.0",' : '' %>
    "eslint": "7.32.0",
    "eslint-config-airbnb-typescript": "17.0.0",
    "eslint-config-prettier": "8.3.0",
    "eslint-plugin-prettier": "3.4.0",
    <%- h.CLIENT ? '"eslint-plugin-react": "7.31.10",' : '' %>
    <%- h.CLIENT ? '"eslint-plugin-react-hooks": "4.6.0",' : '' %>
    <%- h.CLIENT ? '"file-loader": "6.2.0",' : '' %>
    "@biorate/hygen": "^0.5.2",
    "lerna": "9.0.3",
    <%- h.CLIENT ? '"less": "4.1.1",' : '' %>
    <%- h.CLIENT ? '"less-loader": "9.0.0",' : '' %>
    <%- h.CLIENT ? '"mini-css-extract-plugin": "1.6.0",' : '' %>
    "minimist": "1.2.6",
    "node-gyp": "8.4.1",
    "npx": "10.2.2",
    "nx": "22.4.5",
    "unplugin-swc": "1.5.3",
    "vite": "6.3.5",
    "vitest": "4.1.5",
    <%- h.CLIENT ? '"postcss-less": "6.0.0",' : '' %>
    <%- h.CLIENT ? '"postcss-loader": "7.0.0",' : '' %>
    <%- h.CLIENT ? '"postcss-scss": "4.0.9",' : '' %>
    <%- h.CLIENT ? '"postcss-styled-syntax": "0.6.4",' : '' %>
    "prettier": "2.8.8",
    <%- h.CLIENT ? '"pug-html-loader": "1.1.5",' : '' %>
    <%- h.CLIENT ? '"path-browserify": "1.0.1",' : '' %>
    <%- h.CLIENT ? '"process": "0.11.10",' : '' %>
    <%- h.CLIENT ? '"style-loader": "3.3.1",' : '' %>
    <%- h.CLIENT ? '"stylelint": "15",' : '' %>
    <%- h.CLIENT ? '"stylelint-config-idiomatic-order": "10.0.0",' : '' %>
    <%- h.CLIENT ? '"stylelint-config-standard": "34",' : '' %>
    <%- h.CLIENT ? '"stylelint-csstree-validator": "3.0.0",' : '' %>
    <%- h.CLIENT ? '"stylelint-order": "6.0.4",' : '' %>
    <%- h.CLIENT ? '"terser-webpack-plugin": "5.1.2",' : '' %>
    "traverse": "0.6.6",
    <%- h.CLIENT ? '"ts-loader": "9.5.1",' : '' %>
    "ts-node": "10.9.2",
    "tsc-alias": "1.8.16",
    "typedoc": "0.24.8",
    "typescript": "5.0.4"<%- h.CLIENT ? ',' : '' %>
    <%- h.CLIENT ? '"util-browserify": "browserify/node-util#v0.12.4",' : '' %>
    <%- h.CLIENT ? '"webpack": "5.105.0",' : '' %>
    <%- h.CLIENT ? '"webpack-cli": "6.0.1",' : '' %>
    <%- h.CLIENT ? '"webpack-dev-server": "5.2.3"' : '' %>
  },
  "dependencies": {
    "@biorate/auto-object": "2.2.4",
    "@biorate/axios": "3.5.1",
    "@biorate/config": "3.2.5",
    "@biorate/errors": "3.1.3",
    "@biorate/i18n": "2.1.7",
    "@biorate/inversion": "3.1.5",
    "@biorate/symbolic": "3.1.3",
    "@biorate/tools": "3.1.4",
    "cross-env": "7.0.3",
    "husky": "8.0.3",
    "i18next": "23.4.2",
    "lodash": "4.17.23",
    "qs": "6.14.0"
  }
}
