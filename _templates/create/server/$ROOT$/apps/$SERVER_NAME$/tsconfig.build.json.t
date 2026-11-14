---
unless_exists: true
mirror: true
---
{
  "extends": "./tsconfig.json",
  "include": ["index.ts", "src/**/*"],
  "exclude": ["node_modules", "dist", "tests/**/*"]
}
