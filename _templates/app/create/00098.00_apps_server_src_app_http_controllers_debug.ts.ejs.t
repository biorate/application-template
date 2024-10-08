---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/http/controllers/debug.ts`) %>
unless_exists: true
---
import { Controller, Get, Header } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { inject, Types } from '@biorate/inversion';
import { IConfig } from '@biorate/config';
<%- !CUT_EXAMPLES ? "import { GETGoogle } from '../../../api';" : '' %>

@ApiTags('Debug')
@Controller('debug')
export class DebugController {
  @inject(Types.Config) protected config: IConfig;

  @Get()
  @ApiOperation({ summary: 'Debug info' })
  private async get() {
    return {
      name: this.config.get<string>('package.name', 'unknown'),
      version: this.config.get<string>('package.version', 'unknown'),
    };
  }
  <% if (!CUT_EXAMPLES) { %>
  @Get('google')
  @Header('Content-Type', 'text/html')
  @ApiOperation({ summary: 'google' })
  private async google() {
    const { data } = await GETGoogle.fetch();
    return data;
  }
  <% } %>
}
