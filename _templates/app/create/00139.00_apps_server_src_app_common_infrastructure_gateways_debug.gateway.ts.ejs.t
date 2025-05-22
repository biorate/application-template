---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/infrastructure/gateways/debug.gateway.ts`) %>
unless_exists: true
---
import { WebSocket } from 'ws';
import { SubscribeMessage } from '@nestjs/websockets';
import { WsCommonGateway } from '../../../shared';

export class DebugGateway extends WsCommonGateway {
  @SubscribeMessage('hello')
  private onHello(client: WebSocket, data: unknown) {
    return { event: 'world', data: { value: 'world' } };
  }
}
