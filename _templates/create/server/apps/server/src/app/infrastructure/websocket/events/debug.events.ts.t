---
to: <%= h.ADD_WEB_SOCKET && `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/infrastructure/websocket/events/debug.events.ts` %>
unless_exists: true
---
export enum DebugEvents {
  DebugPub = 'debug.pub',
  DebugSub = 'debug.sub',
}
