---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/application/ports/info.driven.port.ts`) %>
unless_exists: true
---
import { Info } from '../../domain';

export interface InfoDrivenPort {
  getInfo(): Promise<Info>;
}
