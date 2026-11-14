---
unless_exists: true
mirror: true
---
import { DebugDrivenPort } from '@/app/application/port';

export class DebugHelloWorldUseCase {
  public constructor(protected readonly debugHttp: DebugDrivenPort) {}

  public async execute() {
    const { name, ENV, version } = await this.debugHttp.getClientConfig();
    return `${ENV}/${name}:${version} -> "Hello world!"`;
  }
}
