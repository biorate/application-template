---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/domain/error/index.ts` %>
unless_exists: true
---
<% if (!h.CUT_EXAMPLES) { -%>
export * from './user.error';
<% } -%>
