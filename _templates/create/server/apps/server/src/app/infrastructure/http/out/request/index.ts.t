---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/infrastructure/http/out/request/index.ts` %>
unless_exists: true
---
export * from './info';
