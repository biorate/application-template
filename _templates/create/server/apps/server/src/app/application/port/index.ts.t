---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/application/port/index.ts` %>
unless_exists: true
---
<%- h.CLIENT ? "export * from './client.driven.port';" : '' -%>
<% if (!h.CUT_EXAMPLES) { -%>
export * from './user.driven.port';
<% } -%>
export * from './info.driven.port';
export * from './debug.driven.port';
