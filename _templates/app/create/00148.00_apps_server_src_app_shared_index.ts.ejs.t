---
to: <%= h.server(`${ROOT}/apps/server/src/app/shared/index.ts`) %>
unless_exists: true
---
export * from './transform';
export * from './ws-common.gateway';
