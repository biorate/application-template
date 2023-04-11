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
