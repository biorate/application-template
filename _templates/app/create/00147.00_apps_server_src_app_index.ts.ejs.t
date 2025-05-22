---
to: <%= h.server(`${ROOT}/apps/server/src/app/index.ts`) %>
unless_exists: true
---
import { MiddlewareConsumer, Module } from '@nestjs/common';
import { ServeStaticModule } from '@nestjs/serve-static';
import { ScheduleModule } from '@nestjs/schedule';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { path } from '@biorate/tools';
import { RequestCountMiddleware, ResponseTimeMiddleware } from '@biorate/nestjs-tools';
import { CommonModule } from './common';

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: path.create(process.cwd(), '../name-of-the-app-client/dist'),
    }),
    EventEmitterModule.forRoot({ verboseMemoryLeak: true }),
    ScheduleModule.forRoot(),
    CommonModule,
  ],
})
export class AppModule {
  public configure(consumer: MiddlewareConsumer) {
    consumer.apply(ResponseTimeMiddleware).forRoutes('*');
    consumer.apply(RequestCountMiddleware).forRoutes('*');
  }
}
