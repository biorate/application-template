---
to: <%= h.server(CLIENT && `${ROOT}/apps/${SERVER_NAME}/src/app/adapter/http/in/client.controller.ts`) %>
unless_exists: true
---
import { Controller, Get } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { controllers, GetLocaleUseCase, SetLocaleUseCase } from '@biorate/nestjs-tools';
import { ClientGetConfigUseCase } from '@/app/application/service';

@ApiTags('Client')
@Controller('client')
export class ClientController extends controllers.ClientController {
  public constructor(
    protected readonly getConfigUseCase: ClientGetConfigUseCase,
    protected readonly getLoc: GetLocaleUseCase,
    protected readonly setLoc: SetLocaleUseCase,
  ) {
    super();
  }

  @Get('config')
  @ApiOperation({ summary: 'Get client config' })
  protected get() {
    return this.getConfigUseCase.execute();
  }
}
