---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/service/debug/debug.hello-world.use-case.ts`) %>
unless_exists: true
---
import { DebugDrivenPort } from '@/app/application/port';

export class DebugHelloWorldUseCase {
  public constructor(protected readonly debugHttp: DebugDrivenPort) {}

  public async execute() {
    const { name, ENV, version } = await this.debugHttp.getClientConfig();
    return `${ENV}/${name}:${version} -> "Hello world!"`;
  }
}
