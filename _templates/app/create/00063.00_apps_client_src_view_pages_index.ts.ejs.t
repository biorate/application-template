---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/pages/index.ts`) %>
unless_exists: true
---
export * from './main';
export * from './cart';
