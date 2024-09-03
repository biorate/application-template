---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/components/index.ts`) %>
unless_exists: true
---
export * from './hello';
export * from './spinner';
