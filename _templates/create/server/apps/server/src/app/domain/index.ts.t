---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/domain/index.ts` %>
unless_exists: true
---
<% if (!h.CUT_EXAMPLES) { -%>
export * from './user';
export * from './error';
<% } -%>
export * from './client';
export * from './info';
