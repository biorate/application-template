import { join } from 'path';
import * as ResponseTime from 'response-time';
import { Module, MiddlewareConsumer } from '@nestjs/common';
import { ServeStaticModule } from '@nestjs/serve-static';
import { APP_GUARD } from '@nestjs/core';
import { RolesGuard } from './providers';
import { ProbeController } from './controllers/probe';
import { MetricsController } from './controllers/metrics';

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(__dirname, '../../..', 'client/dist'),
    }),
  ],
  controllers: [ProbeController, MetricsController],
  providers: [
    {
      provide: APP_GUARD,
      useClass: RolesGuard,
    },
  ],
})
export class AppModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(ResponseTime()).forRoutes('*');
  }
}
