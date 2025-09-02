---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/adapter/persistence/index.ts`) %>
unless_exists: true
---
<% if (!CUT_EXAMPLES) { -%>
export * from './user.repository.adapter';
<% } -%>
<%- CLIENT ? "export * from './client.repository.adapter';" : '' -%>
export * from './info.repository.adapter';
