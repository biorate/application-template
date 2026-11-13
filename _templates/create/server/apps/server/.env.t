---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/.env` %>
unless_exists: true
---
METADATA_SERVER_DETECTION=none
