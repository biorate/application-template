---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/infrastructure/request/dto/index.ts`) %>
unless_exists: true
---
export * from './info';
