---
unless_exists: true
mirror: true
skip: <%= !h.CLIENT && 'client action not requested' %>
---
export * from './client.get-config.use-case';
