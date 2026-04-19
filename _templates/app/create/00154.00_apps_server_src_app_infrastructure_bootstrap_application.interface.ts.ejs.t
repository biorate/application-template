---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/infrastructure/bootstrap/application.interface.ts`) %>
unless_exists: true
---
import { INestApplication } from '@nestjs/common';

export interface IApplication<T = unknown> {
  app: INestApplication<T>;
}
