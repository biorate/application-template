---
to: <%= `${h.ROOT}/apps/${h.CLIENT_NAME}/tests/common/spec.ts` %>
unless_exists: true
---
export abstract class Spec {}
