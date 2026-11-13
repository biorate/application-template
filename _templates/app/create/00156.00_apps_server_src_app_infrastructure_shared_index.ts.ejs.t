---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/infrastructure/shared/index.ts`) %>
unless_exists: true
---
export * from './transform';
<% if (ADD_WEB_SOCKET) { -%>
export * from './ws-common.gateway';
<% } -%>
