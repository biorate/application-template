---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/ports/debug.provider.port.ts`) %>
unless_exists: true
---
import { Info } from '../../domain';

export interface DebugProviderPort {
  getClientConfig(): Promise<Info>;
}
