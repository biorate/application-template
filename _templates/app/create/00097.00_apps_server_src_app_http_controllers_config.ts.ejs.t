---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/http/controllers/config.ts`) %>
unless_exists: true
---
import { Controller, Get } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { inject, Types } from '@biorate/inversion';
import { IConfig } from '@biorate/config';

@ApiTags('Config')
@Controller('config')
export class ConfigController {
  @inject(Types.Config) protected config: IConfig;

  @Get()
  @ApiOperation({ summary: 'Get client config' })
  protected get() {
    return {
      ENV: this.config.get<string>('ENV', 'debug'),
    };
  }
}
