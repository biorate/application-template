---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/adapter/index.ts`) %>
unless_exists: true
---
export * from './http/in';
export * from './http/out';
export * from './persistence';
<% if (ADD_WEB_SOCKET) { %>
export * from './websocket';
<% } -%>
