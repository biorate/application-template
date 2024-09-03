---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/src/enums/index.ts`) %>
unless_exists: true
---
export * from './user';
