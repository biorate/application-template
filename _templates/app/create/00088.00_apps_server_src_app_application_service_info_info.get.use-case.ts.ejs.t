---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/service/info/info.get.use-case.ts`) %>
unless_exists: true
---
import { Inject, Injectable } from '@nestjs/common';
import { Types } from '@biorate/inversion';
import { InfoProviderPort } from '../../ports';

@Injectable()
export class InfoGetUseCase {
  @Inject(Types.InfoProviderPort)
  protected readonly infoRepository: InfoProviderPort;

  public execute() {
    return this.infoRepository.getInfo();
  }
}
