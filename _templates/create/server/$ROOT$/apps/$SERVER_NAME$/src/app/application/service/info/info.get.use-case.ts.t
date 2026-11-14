---
unless_exists: true
mirror: true
---
import { InfoDrivenPort } from '@/app/application/port';

export class InfoGetUseCase {
  public constructor(protected readonly infoRepository: InfoDrivenPort) {}

  public execute() {
    return this.infoRepository.getInfo();
  }
}
