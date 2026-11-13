---
to: <%= h.root(`${h.ROOT}/pnpm-workspace.yaml`) %>
unless_exists: true
---
packages:
  - apps/*
  - packages/*
