import { join } from 'path';
import { Module, MiddlewareConsumer } from '@nestjs/common';
import { ServeStaticModule } from '@nestjs/serve-static';
import { APP_GUARD } from '@nestjs/core';
import {
  ResponseTimeMiddleware,
  RequestCountMiddleware,
  RolesGuardProvider,
} from '@biorate/nestjs-tools';
import { WebsocketGateway } from './websocket';
import * as controllers from './controllers';
import { DebugController } from './controllers/debug';

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(process.cwd(), '../client/dist'),
    }),
    WebsocketGateway,
  ],
  controllers: [
    ...Object.values(controllers),
    ...(process.env.NODE_ENV === 'production' ? [] : [DebugController]),
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: RolesGuardProvider,
    },
  ],
})
export class AppModule {
  public configure(consumer: MiddlewareConsumer) {
    consumer.apply(ResponseTimeMiddleware).forRoutes('*');
    consumer.apply(RequestCountMiddleware).forRoutes('*');
  }
}
