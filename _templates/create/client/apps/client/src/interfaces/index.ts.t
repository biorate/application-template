---
to: <%= `${h.ROOT}/apps/${h.CLIENT_NAME}/src/interfaces/index.ts` %>
unless_exists: true
---
export * from './i-error';
