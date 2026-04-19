---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/infrastructure/http/out/index.ts`) %>
unless_exists: true
---
export * from './debug.http.adapter';
