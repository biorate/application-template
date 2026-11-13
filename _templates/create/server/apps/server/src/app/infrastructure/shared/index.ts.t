---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/infrastructure/shared/index.ts` %>
unless_exists: true
---
export * from './transform';
<% if (h.ADD_WEB_SOCKET) { -%>
export * from './ws-common.gateway';
<% } -%>
