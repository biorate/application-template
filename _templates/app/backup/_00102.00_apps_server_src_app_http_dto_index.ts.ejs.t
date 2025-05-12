---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/src/app/http/dto/index.ts`) %>
unless_exists: true
---
export * from './crud';
