---
to: <%= `${h.ROOT}/apps/${h.CLIENT_NAME}/src/api/index.ts` %>
unless_exists: true
---
export * from './config';
