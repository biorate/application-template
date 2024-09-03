---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/logger/index.ts`) %>
unless_exists: true
---
export * from './logger';
