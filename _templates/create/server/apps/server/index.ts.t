---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/index.ts` %>
unless_exists: true
---
import './src';
