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
