---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/ws/common.ts`) %>
unless_exists: true
---
import { UseFilters } from '@nestjs/common';
import { WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { AllExceptionsFilter } from '@biorate/nestjs-tools';
import { Server } from 'ws';

@WebSocketGateway()
@UseFilters(new AllExceptionsFilter())
export class WsGateway {
  @WebSocketServer()
  protected server: Server;
}
