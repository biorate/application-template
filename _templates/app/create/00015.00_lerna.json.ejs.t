---
to: <%= h.root(`${ROOT}/lerna.json`) %>
unless_exists: true
---
{
  "$schema": "node_modules/lerna/schemas/lerna-schema.json",
  "version": "independent",
  "command": {
    "version": {
      "allowBranch": ["master", "release/*", "feature/*", "bugfix/*", "feat/*", "fix/*"],
      "conventionalCommits": true,
      "changelog": true,
      "message": "chore: %s",
      "ignoreChanges": [
        "**/tests/**",
        "**/*.test.ts",
        "**/*.spec.ts",
        "**/__snapshots__/**",
        "**/__mocks__/**",
        "**/*.md",
        "**/package-lock.json",
        "**/pnpm-lock.yaml",
        "**/.npmrc",
        "**/.gitignore",
        "**/jest.config.js",
        "**/tsconfig.tsbuildinfo"
      ]
    }
  },
  "npmClient": "pnpm"
}
