---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/infrastructure/http/in/index.ts` %>
unless_exists: true
---
export * from './info.controller';
<%- h.CLIENT ? "export * from './client.controller';" : '' -%>
<% if (!h.CUT_EXAMPLES) { -%>
export * from './user.controller';
<% } -%>
