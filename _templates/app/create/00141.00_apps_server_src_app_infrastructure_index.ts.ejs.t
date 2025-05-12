---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/infrastructure/index.ts`) %>
unless_exists: true
---
export * from './adapters';
