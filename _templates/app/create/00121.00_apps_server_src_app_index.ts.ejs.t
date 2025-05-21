---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/index.ts`) %>
unless_exists: true
---
import { Types } from '@biorate/inversion';
import { MiddlewareConsumer, Module } from '@nestjs/common';
<%- CLIENT ? "import { ServeStaticModule } from '@nestjs/serve-static';" : '' %>;
<%- CLIENT ? "import { path } from '@biorate/tools';" : '' %>;
import {
  RequestCountMiddleware,
  ResponseTimeMiddleware,
  <% if (CLIENT) { -%>
  GetLocaleUseCase,
  SetLocaleUseCase,
  <% } -%>
  GetMetricsUseCase,
  MetricsRepositoryAdapter,
  controllers as C,
} from '@biorate/nestjs-tools';
import {
  <% if (!CUT_EXAMPLES) { -%>
  UserRepositoryAdapter,
  <% } -%>
  <%- CLIENT ? 'ClientRepositoryAdapter,' : '' -%>
  DebugHttpAdapter,
  InfoRepositoryAdapter,
} from './infrastructure';
import * as useCases from './application/service';
<%- ADD_WEB_SOCKET ? "import * as gateways from './infrastructure/gateways';" : '' -%>
import * as controllers from './infrastructure/controllers';
import { DebugController } from './infrastructure/controllers/debug.controller';

@Module({
  imports: [
    <%- CLIENT ? `ServeStaticModule.forRoot({ rootPath: path.create(process.cwd(), '../${CLIENT_NAME}/dist'), }),` : '' -%>
    <%- ADD_WEB_SOCKET ? '...Object.values(gateways),' : '' -%>
  ],
  controllers: [
    ...Object.values(controllers),
    ...(process.env.NODE_ENV !== 'production' ? [DebugController] : []),
    ...Object.values(C)<%- !CLIENT ? '.filter((item) => C.ClientController !== item)' : '' -%>,
  ],
  providers: [
    <% if (CLIENT) { -%>
    GetLocaleUseCase,
    SetLocaleUseCase,
    <% } -%>
    GetMetricsUseCase,
    ...Object.values(useCases),
    <% if (!CUT_EXAMPLES) { -%>
    {
      provide: Types.UserDrivenPort,
      useClass: UserRepositoryAdapter,
    },
    <% } -%>
    <% if (CLIENT) { -%>
    {
      provide: Types.ClientDrivenPort,
      useClass: ClientRepositoryAdapter,
    },
    <% } -%>
    {
      provide: Types.MetricsDrivenPort,
      useClass: MetricsRepositoryAdapter,
    },
    {
      provide: Types.InfoDrivenPort,
      useClass: InfoRepositoryAdapter,
    },
    {
      provide: Types.DebugDrivenPort,
      useClass: DebugHttpAdapter,
    },
  ],
})
export class AppModule {
  public configure(consumer: MiddlewareConsumer) {
    consumer.apply(ResponseTimeMiddleware).forRoutes('*');
    consumer.apply(RequestCountMiddleware).forRoutes('*');
  }
}
