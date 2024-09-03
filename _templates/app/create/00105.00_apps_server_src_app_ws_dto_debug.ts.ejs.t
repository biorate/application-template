---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/ws/dto/debug.ts`) %>
unless_exists: true
---
import { IsString } from 'class-validator';

export class DebugHelloDTO {
  @IsString()
  value: string;
}
