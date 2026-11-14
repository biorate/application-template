---
unless_exists: true
mirror: true
skip: <%= !h.ADD_WEB_SOCKET && 'web socket not requested' %>
---
export enum DebugEvents {
  DebugPub = 'debug.pub',
  DebugSub = 'debug.sub',
}
