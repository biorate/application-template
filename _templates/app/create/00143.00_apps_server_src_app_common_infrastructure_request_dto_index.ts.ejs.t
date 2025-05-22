---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/infrastructure/request/dto/index.ts`) %>
unless_exists: true
---
export * from './info';
