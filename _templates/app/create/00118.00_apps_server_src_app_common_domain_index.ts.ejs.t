---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/domain/index.ts`) %>
unless_exists: true
---
export * from './user';
export * from './client';
export * from './info';
