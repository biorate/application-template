---
sh: <%= `npx fse copy ${templates}/create/server/bin/favicon.ico ${h.ROOT}/apps/${h.SERVER_NAME}/favicon.ico` %>
unless_exists: true
---
