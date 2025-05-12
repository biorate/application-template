---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/src/api/index.ts`) %>
unless_exists: true
---
export * from './google';
