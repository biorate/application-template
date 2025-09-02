---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/adapter/http/in/index.ts`) %>
unless_exists: true
---
export * from './info.controller';
<%- CLIENT ? "export * from './client.controller';" : '' -%>
<% if (!CUT_EXAMPLES) { -%>
export * from './user.controller';
<% } -%>
