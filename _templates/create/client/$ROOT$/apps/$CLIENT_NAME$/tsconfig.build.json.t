---
unless_exists: true
mirror: true
---
{
  "extends": "./tsconfig.json",
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "tests/**/*"]
}
