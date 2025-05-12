---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/infrastructure/adapters/debug.http.adapter.ts`) %>
unless_exists: true
---
import { Injectable } from '@nestjs/common';
import { DebugProviderPort } from '../../application/ports';
import { Info } from '../../domain';
import { GETInfo } from '../request';

@Injectable()
export class DebugHttpAdapter implements DebugProviderPort {
  public async getClientConfig() {
    const { data } = await GETInfo.fetch({});
    return new Info(data);
  }
}
