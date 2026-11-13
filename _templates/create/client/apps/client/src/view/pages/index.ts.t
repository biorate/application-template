---
to: <%= `${h.ROOT}/apps/${h.CLIENT_NAME}/src/view/pages/index.ts` %>
unless_exists: true
---
export * from './foo';
export * from './bar';
