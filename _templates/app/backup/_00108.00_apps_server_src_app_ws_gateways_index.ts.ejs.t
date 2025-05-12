---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/ws/gateways/index.ts`) %>
unless_exists: true
---
export * from './debug';
