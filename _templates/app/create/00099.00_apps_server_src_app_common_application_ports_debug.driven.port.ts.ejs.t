---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/application/ports/debug.driven.port.ts`) %>
unless_exists: true
---
import { Info } from '../../domain';

export interface DebugDrivenPort {
  getClientConfig(): Promise<Info>;
}
