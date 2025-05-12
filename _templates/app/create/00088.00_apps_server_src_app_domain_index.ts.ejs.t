---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/domain/index.ts`) %>
unless_exists: true
---
<% if (!CUT_EXAMPLES) { -%>
export * from './user';
<% } -%>
export * from './client';
export * from './info';
