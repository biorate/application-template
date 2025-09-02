---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/adapter/websocket/dto/debug/index.ts`) %>
unless_exists: true
---
export * from './debug.dto';
