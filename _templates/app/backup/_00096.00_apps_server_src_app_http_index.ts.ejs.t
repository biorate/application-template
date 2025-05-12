---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/http/index.ts`) %>
unless_exists: true
---
import { Module, MiddlewareConsumer } from '@nestjs/common';
<%- CLIENT ? "import { ServeStaticModule } from '@nestjs/serve-static';" : '' %>;
import { APP_GUARD } from '@nestjs/core';
<%- CLIENT ? "import { path } from '@biorate/tools';" : '' %>;
import {
  ResponseTimeMiddleware,
  RequestCountMiddleware,
  RolesGuardProvider,
} from '@biorate/nestjs-tools';
import * as controllers from './controllers';
import { DebugController } from './controllers/debug';

@Module({
  imports: [
    <%- CLIENT ? `ServeStaticModule.forRoot({ rootPath: path.create(process.cwd(), '../${CLIENT_NAME}/dist'), }),` : '' %>
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
export class HttpModule {
  public configure(consumer: MiddlewareConsumer) {
    consumer.apply(ResponseTimeMiddleware).forRoutes('*');
    consumer.apply(RequestCountMiddleware).forRoutes('*');
  }
}
