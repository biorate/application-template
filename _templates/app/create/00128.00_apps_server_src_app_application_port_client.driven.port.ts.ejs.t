---
to: <%= h.server(CLIENT && `${ROOT}/apps/${SERVER_NAME}/src/app/application/port/client.driven.port.ts`) %>
unless_exists: true
---
import { ClientDrivenPort as CommonClientDrivenPort } from '@biorate/nestjs-tools';
import { ClientConfig } from '@/app/domain';

export interface ClientDrivenPort extends CommonClientDrivenPort {
  getConfig(): Promise<ClientConfig>;
}
