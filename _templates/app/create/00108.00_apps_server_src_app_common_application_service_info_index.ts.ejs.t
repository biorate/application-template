---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/application/service/info/index.ts`) %>
unless_exists: true
---
export * from './info.get.use-case';
