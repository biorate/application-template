---
unless_exists: true
mirror: true
---
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "types": ["node", "vitest/globals"],
    "baseUrl": "./",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["index.ts", "src/**/*", "tests/**/*"],
  "exclude": ["node_modules", "dist"]
}
