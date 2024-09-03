---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/errors/index.ts`) %>
unless_exists: true
---
export * from './base-error';
export * from './unknown-error';
