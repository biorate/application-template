---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/application/service/index.ts`) %>
unless_exists: true
---
export * from './user';
export * from './client';
export * from './info';
export * from './debug';
