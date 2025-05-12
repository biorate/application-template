---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/application/service/debug/debug.hello-world.use-case.ts`) %>
unless_exists: true
---
import { Inject, Injectable } from '@nestjs/common';
import { Types } from '@biorate/inversion';
import { DebugProviderPort } from '../../ports';

@Injectable()
export class DebugHelloWorldUseCase {
  @Inject(Types.DebugProviderPort)
  protected readonly debugHttp: DebugProviderPort;

  public async execute() {
    const { name, ENV, version } = await this.debugHttp.getClientConfig();
    return `${ENV}/${name}:${version} -> "Hello world!"`;
  }
}
