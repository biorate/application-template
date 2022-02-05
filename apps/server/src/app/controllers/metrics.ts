import { inject, Types } from '@biorate/inversion';
import { Controller, Get } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { IPrometheus } from '@biorate/prometheus';

@ApiTags('Metrics')
@Controller('metrics')
export class MetricsController {
  @inject(Types.Prometheus) protected prometheus: IPrometheus;

  @Get()
  @ApiOperation({ summary: 'Prometheus metrics hook' })
  private async readiness() {
    return this.prometheus.registry.metrics();
  }
}
