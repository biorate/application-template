---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/index.ts`) %>
unless_exists: true
---
import { Module } from '@nestjs/common';
import { HttpModule } from './http';
<%- ADD_WEB_SOCKET ? "import { WsModule } from './ws';" : '' -%>

@Module({
  imports: [HttpModule<%- ADD_WEB_SOCKET ? ', WsModule' : '' %>],
})
export class AppModule {}
