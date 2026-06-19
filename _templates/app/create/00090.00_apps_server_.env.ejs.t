---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/.env`) %>
unless_exists: true
---
METADATA_SERVER_DETECTION=none
