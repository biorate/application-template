---
to: <%= `${h.ROOT}/apps/${h.CLIENT_NAME}/src/view/containers/index.ts` %>
unless_exists: true
---
export * from './app';
export * from './layout';
