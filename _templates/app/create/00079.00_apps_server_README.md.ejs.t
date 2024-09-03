---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/README.md`) %>
unless_exists: true
---
# <%= SERVICE_NAME %> server

## <%= SERVICE_DESCRIPTION %>
