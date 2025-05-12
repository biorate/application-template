---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/http/controllers/index.ts`) %>
unless_exists: true
---
export {
  ProbeController,
  MetricsController,
  LocalesController,
} from '@biorate/nestjs-tools';
<%- !CLIENT ? "export * from './info';" : '' %>
<%- CLIENT ? "export * from './config';" : '' %>
