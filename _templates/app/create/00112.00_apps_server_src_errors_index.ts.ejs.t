---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/src/errors/index.ts`) %>
unless_exists: true
---
export * from './authorize';
