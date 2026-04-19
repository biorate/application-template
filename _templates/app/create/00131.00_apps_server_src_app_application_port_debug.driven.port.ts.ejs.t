---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/port/debug.driven.port.ts`) %>
unless_exists: true
---
import { Info } from '@/app/domain';

export interface DebugDrivenPort {
  getClientConfig(): Promise<Info>;
}
