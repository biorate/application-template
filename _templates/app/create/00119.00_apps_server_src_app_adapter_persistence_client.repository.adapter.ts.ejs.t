---
to: <%= h.server(CLIENT && `${ROOT}/apps/${SERVER_NAME}/src/app/adapter/persistence/client.repository.adapter.ts`) %>
unless_exists: true
---
import { Injectable } from '@nestjs/common';
import { inject, Types } from '@biorate/inversion';
import { IConfig } from '@biorate/config';
import { ClientRepositoryAdapter as CommonClientRepositoryAdapter } from '@biorate/nestjs-tools';
import { ClientDrivenPort } from '@/app/application/port';
import { ClientConfig } from '@/app/domain';

@Injectable()
export class ClientRepositoryAdapter
  extends CommonClientRepositoryAdapter
  implements ClientDrivenPort
{
  @inject(Types.Config) protected config: IConfig;

  public async getConfig() {
    return new ClientConfig({
      ENV: this.config.get<string>('ENV', 'debug'),
      version: this.config.get<string>('package.version'),
    });
  }
}
