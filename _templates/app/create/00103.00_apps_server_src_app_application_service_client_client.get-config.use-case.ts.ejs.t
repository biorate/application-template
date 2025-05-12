---
to: <%= h.server(CLIENT && `${ROOT}/apps/${SERVER_NAME}/src/app/application/service/client/client.get-config.use-case.ts`) %>
unless_exists: true
---
import { Inject, Injectable } from '@nestjs/common';
import { Types } from '@biorate/inversion';
import { ClientProviderPort } from '../../ports';

@Injectable()
export class ClientGetConfigUseCase {
  @Inject(Types.ClientProviderPort)
  protected readonly clientRepository: ClientProviderPort;

  public async execute() {
    return this.clientRepository.getConfig();
  }
}
