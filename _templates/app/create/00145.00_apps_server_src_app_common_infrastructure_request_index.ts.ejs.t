---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/infrastructure/request/index.ts`) %>
unless_exists: true
---
export * from './info';
