---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/port/info.driven.port.ts`) %>
unless_exists: true
---
import { Info } from '@/app/domain';

export interface InfoDrivenPort {
  getInfo(): Promise<Info>;
}
