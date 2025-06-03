---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/shared/ws-common.gateway.ts`) %>
unless_exists: true
---
import { Server } from 'ws';
import { WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { UseFilters, UsePipes, ValidationPipe } from '@nestjs/common';
import { AllExceptionsFilter } from '@biorate/nestjs-tools';

@WebSocketGateway()
@UsePipes(new ValidationPipe({ transform: true }))
@UseFilters(new AllExceptionsFilter())
export abstract class WsCommonGateway {
  @WebSocketServer()
  protected server: Server;
}

