---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/common/infrastructure/gateways/events/index.ts`) %>
unless_exists: true
---
export * from './debug.events';
