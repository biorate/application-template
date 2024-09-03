---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/interfaces.ts`) %>
unless_exists: true
---
import { INestApplication } from '@nestjs/common';

export interface IApplication {
  app: INestApplication;
}
