---
unless_exists: true
mirror: true
---
<% if (!h.CUT_EXAMPLES) { -%>
export * from './user.repository.adapter';
<% } -%>
<%- h.CLIENT ? "export * from './client.repository.adapter';" : '' -%>
export * from './info.repository.adapter';
