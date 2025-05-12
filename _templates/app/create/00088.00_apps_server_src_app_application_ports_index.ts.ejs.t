---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/ports/index.ts`) %>
unless_exists: true
---
<%- CLIENT ? "export * from './client.provider.port';" : '' -%>
<% if (!CUT_EXAMPLES) { -%>
export * from './user.provider.port';
<% } -%>
export * from './info.provider.port';
export * from './debug.provider.port';
