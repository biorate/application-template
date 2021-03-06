import { Controller, Get } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('Probe')
@Controller('probe')
export class ProbeController {
  @Get('readiness')
  @ApiOperation({ summary: 'Readiness probe' })
  private async readiness() {
    return 1;
  }

  @Get('healthz')
  @ApiOperation({ summary: 'Healthz probe' })
  private async healthz() {
    return 1;
  }
}
