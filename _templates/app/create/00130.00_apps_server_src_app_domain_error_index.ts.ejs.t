---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/domain/error/index.ts`) %>
unless_exists: true
---
<% if (!CUT_EXAMPLES) { -%>
export * from './user.error';
<% } -%>
