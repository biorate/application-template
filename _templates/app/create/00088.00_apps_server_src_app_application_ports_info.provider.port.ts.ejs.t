---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/ports/info.provider.port.ts`) %>
unless_exists: true
---
import { Info } from '../../domain';

export interface InfoProviderPort {
  getInfo(): Promise<Info>;
}
