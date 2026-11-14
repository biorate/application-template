---
unless_exists: true
mirror: true
---
import { INestApplication } from '@nestjs/common';

export interface IApplication<T = unknown> {
  app: INestApplication<T>;
}
