---
unless_exists: true
mirror: true
skip: <%= !h.ADD_WEB_SOCKET && 'web socket not requested' %>
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
