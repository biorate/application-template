import { Module } from '@nestjs/common';
import { HttpModule } from './http';
import { WsModule } from './ws';

@Module({
  imports: [HttpModule, WsModule],
})
export class AppModule {}
