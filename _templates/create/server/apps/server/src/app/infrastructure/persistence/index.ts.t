---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/infrastructure/persistence/index.ts` %>
unless_exists: true
---
<% if (!h.CUT_EXAMPLES) { -%>
export * from './user.repository.adapter';
<% } -%>
<%- h.CLIENT ? "export * from './client.repository.adapter';" : '' -%>
export * from './info.repository.adapter';
