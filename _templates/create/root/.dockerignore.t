---
to: <%= h.root(`${h.ROOT}/.dockerignore`) %>
unless_exists: true
---
.git
coverage
node_modules
<%= h.CLIENT ? `apps/${h.CLIENT_NAME}/node_modules` : '' %>
<%= h.SERVER ? `apps/${h.SERVER_NAME}/node_modules` : '' %>
.dockerignore
Dockerfile
docker-compose.yml
