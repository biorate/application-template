---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/infrastructure/index.ts`) %>
unless_exists: true
---
export * from './adapters';
