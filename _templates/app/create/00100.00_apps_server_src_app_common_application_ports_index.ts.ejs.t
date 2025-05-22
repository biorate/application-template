---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/application/ports/index.ts`) %>
unless_exists: true
---
export * from './client.driven.port';
export * from './user.driven.port';
export * from './info.driven.port';
export * from './debug.driven.port';
