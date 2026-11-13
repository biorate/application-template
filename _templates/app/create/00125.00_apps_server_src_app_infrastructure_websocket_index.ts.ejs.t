---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/infrastructure/websocket/index.ts`) %>
unless_exists: true
---
export * from './debug.gateway';
