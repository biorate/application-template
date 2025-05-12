---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/ws/index.ts`) %>
unless_exists: true
---
import { Module } from '@nestjs/common';
import * as gateways from './gateways';

@Module({
  imports: Object.values(gateways),
})
export class WsModule {}
