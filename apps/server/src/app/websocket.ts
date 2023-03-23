import {
  SubscribeMessage,
  WebSocketGateway,
  // WebSocketServer,
  // WsResponse,
} from '@nestjs/websockets';
// import { Server } from 'ws';

@WebSocketGateway()
export class WebsocketGateway {
  @SubscribeMessage('events')
  onEvents(client: any, data: any) {
    return { event: 'events', data };
  }

  @SubscribeMessage('test')
  onTest(client: any, data: any) {
    return { event: 'test', data };
  }
}
