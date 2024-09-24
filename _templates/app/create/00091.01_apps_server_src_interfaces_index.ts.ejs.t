---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/interfaces/index.ts`) %>
unless_exists: true
---
export * from './application';
