---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/application/service/index.ts` %>
unless_exists: true
---
<% if (!h.CUT_EXAMPLES) { -%>
export * from './user';
<% } -%>
<%- h.CLIENT ? "export * from './client';" : '' -%>
export * from './info';
export * from './debug';
