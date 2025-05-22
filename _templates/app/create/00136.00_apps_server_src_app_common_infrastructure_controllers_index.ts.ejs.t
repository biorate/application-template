---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/infrastructure/controllers/index.ts`) %>
unless_exists: true
---
export * from './info.controller';
export * from './client.controller';
export * from './user.controller';
