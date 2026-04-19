---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/infrastructure/bootstrap/index.ts`) %>
unless_exists: true
---
export type { IApplication } from './application.interface';
export { Application } from './application';
export { Root } from './root-config';
