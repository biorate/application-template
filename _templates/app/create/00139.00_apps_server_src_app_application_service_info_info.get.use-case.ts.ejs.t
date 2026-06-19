---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/service/info/info.get.use-case.ts`) %>
unless_exists: true
---
import { InfoDrivenPort } from '@/app/application/port';

export class InfoGetUseCase {
  public constructor(protected readonly infoRepository: InfoDrivenPort) {}

  public execute() {
    return this.infoRepository.getInfo();
  }
}
