---
to: <%= h.ADD_WEB_SOCKET && `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/infrastructure/websocket/events/index.ts` %>
unless_exists: true
---
export * from './debug.events';
