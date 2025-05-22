---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/infrastructure/gateways/index.ts`) %>
unless_exists: true
---
export * from './debug.gateway';
