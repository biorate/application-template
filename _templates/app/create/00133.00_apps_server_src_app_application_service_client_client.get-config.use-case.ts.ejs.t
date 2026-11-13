---
to: <%= h.server(CLIENT && `${ROOT}/apps/${SERVER_NAME}/src/app/application/service/client/client.get-config.use-case.ts`) %>
unless_exists: true
---
import { ClientDrivenPort } from '@/app/application/port';

export class ClientGetConfigUseCase {
  public constructor(protected readonly clientRepository: ClientDrivenPort) {}

  public async execute() {
    return this.clientRepository.getConfig();
  }
}
