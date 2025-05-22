---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/application/service/client/index.ts`) %>
unless_exists: true
---
export * from './client.get-config.use-case';
