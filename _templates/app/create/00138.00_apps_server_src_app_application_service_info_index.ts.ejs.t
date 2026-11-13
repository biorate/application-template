---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/service/info/index.ts`) %>
unless_exists: true
---
export * from './info.get.use-case';
