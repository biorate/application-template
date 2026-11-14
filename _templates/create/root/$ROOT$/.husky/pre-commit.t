---
unless_exists: true
mirror: true
---
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"

pnpm run hooks:pre-commit
