---
unless_exists: true
mirror: true
skip: <%= !h.CLIENT && 'client action not requested' %>
---
import { ClientDrivenPort as CommonClientDrivenPort } from '@biorate/nestjs-tools';
import { ClientConfig } from '@/app/domain';

export interface ClientDrivenPort extends CommonClientDrivenPort {
  getConfig(): Promise<ClientConfig>;
}
