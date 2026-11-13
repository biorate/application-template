---
to: <%= h.CLIENT && `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/application/service/client/index.ts` %>
unless_exists: true
---
export * from './client.get-config.use-case';
