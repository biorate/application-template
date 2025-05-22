---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/application/errors/index.ts`) %>
unless_exists: true
---
export * from './user.errors';
