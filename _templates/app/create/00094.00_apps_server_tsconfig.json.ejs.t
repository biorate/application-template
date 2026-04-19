---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tsconfig.json`) %>
unless_exists: true
---
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "baseUrl": "./",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["index.ts", "src/**/*", "tests/**/*"],
  "exclude": ["node_modules", "dist"]
}
