---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/infrastructure/index.ts` %>
unless_exists: true
---
export * from './http/in';
export * from './http/out';
export * from './persistence';
<% if (h.ADD_WEB_SOCKET) { %>
export * from './websocket';
<% } -%>
