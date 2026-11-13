---
sh: "
  npx prettier --write <%= h.ROOT %>
  <%- h.platform === 'linux' ? `&& chmod ug+x ${h.ROOT}/.husky/*` : '' %>
"
---
