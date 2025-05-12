---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/ws/gateways/debug.ts`) %>
unless_exists: true
---
import { WebSocket } from 'ws';
import { SubscribeMessage } from '@nestjs/websockets';
import { DebugHelloDTO } from '../dto';
import { WsGateway } from '../common';

export class DebugGateway extends WsGateway {
  @SubscribeMessage('hello')
  private onHello(client: WebSocket, data: DebugHelloDTO) {
    return { event: 'world', data: { value: 'world' } };
  }
}
