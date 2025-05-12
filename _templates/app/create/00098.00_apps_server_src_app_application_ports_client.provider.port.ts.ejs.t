---
to: <%= h.server(CLIENT && `${ROOT}/apps/${SERVER_NAME}/src/app/application/ports/client.provider.port.ts`) %>
unless_exists: true
---
import { ClientProviderPort as CommonClientProviderPort } from '@biorate/nestjs-tools';
import { ClientConfig } from '../../domain';

export interface ClientProviderPort extends CommonClientProviderPort {
  getConfig(): Promise<ClientConfig>;
}
