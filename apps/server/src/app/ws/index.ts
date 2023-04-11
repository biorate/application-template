import { Module } from '@nestjs/common';
import * as gateways from './gateways';

@Module({
  imports: Object.values(gateways),
})
export class WsModule {}
