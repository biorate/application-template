---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/types/index.ts`) %>
unless_exists: true
---
export * from './IError';