---
unless_exists: true
mirror: true
skip: <%= !h.CLIENT && 'client action not requested' %>
---
import { ClientDrivenPort } from '@/app/application/port';

export class ClientGetConfigUseCase {
  public constructor(protected readonly clientRepository: ClientDrivenPort) {}

  public async execute() {
    return this.clientRepository.getConfig();
  }
}
