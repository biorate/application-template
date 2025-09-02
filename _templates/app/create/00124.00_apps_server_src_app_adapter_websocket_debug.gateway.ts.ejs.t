---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/adapter/websocket/debug.gateway.ts`) %>
unless_exists: true
---
import { SubscribeMessage, MessageBody } from '@nestjs/websockets';
import { AsyncApiPub, AsyncApiSub } from 'nestjs-asyncapi';
import { WsCommonGateway } from '@/app/shared';
import { SUBDebugDTO, PUBDebugDTO, PUBDebugDataDTO } from './dto/debug';
import { DebugEvents } from './events';

export class DebugGateway extends WsCommonGateway {
  @AsyncApiPub({
    channel: DebugEvents.DebugPub,
    message: {
      payload: PUBDebugDTO,
    },
  })
  @AsyncApiSub({
    channel: DebugEvents.DebugSub,
    message: {
      payload: SUBDebugDTO,
    },
  })
  @SubscribeMessage(DebugEvents.DebugPub)
  private onDebug(@MessageBody() data: PUBDebugDataDTO): SUBDebugDTO {
    return { event: DebugEvents.DebugSub, data: { hello: data.value } };
  }
}
