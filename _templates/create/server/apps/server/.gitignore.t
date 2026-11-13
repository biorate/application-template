---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/.gitignore` %>
unless_exists: true
---
# Certs
certs

# Config
/config*.json
!/config.json
!/config.debug.json
