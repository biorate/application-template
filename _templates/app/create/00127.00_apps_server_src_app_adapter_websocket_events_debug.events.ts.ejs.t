---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/adapter/websocket/events/debug.events.ts`) %>
unless_exists: true
---
export enum DebugEvents {
  DebugPub = 'debug.pub',
  DebugSub = 'debug.sub',
}
