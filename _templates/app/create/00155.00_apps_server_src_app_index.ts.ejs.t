---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/app/index.ts`) %>
unless_exists: true
---
import { Types } from '@biorate/inversion';
import { MiddlewareConsumer, Module } from '@nestjs/common';
import { EventEmitterModule } from '@nestjs/event-emitter';
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
import {
<% if (!CUT_EXAMPLES) { -%>
  UserCreateUseCase,
  UserDeleteUseCase,
  UserGetUseCase,
  UserListUseCase,
  UserReplaceUseCase,
  UserUpdateUseCase,
<% } -%>
<% if (CLIENT) { -%>
  ClientGetConfigUseCase,
<% } -%>
  DebugHelloWorldUseCase,
  InfoGetUseCase,
} from './application/service';
<%- ADD_WEB_SOCKET ? "import * as gateways from './infrastructure/websocket';" : '' -%>
import * as controllers from './infrastructure/http/in';
import { DebugController } from './infrastructure/http/in/debug.controller';

@Module({
  imports: [
    EventEmitterModule.forRoot({ verboseMemoryLeak: true }),
    <%- CLIENT ? `// Если добавите второй SPA (например admin), регистрируйте его ServeStatic раньше клиента (узкий serveRoot), иначе catch-all клиента перехватит префикс.
    ServeStaticModule.forRoot({ rootPath: path.create(process.cwd(), '../${CLIENT_NAME}/dist'), }),` : '' -%>
    <%- ADD_WEB_SOCKET ? '...Object.values(gateways),' : '' -%>
  ],
  controllers: [
    ...Object.values(controllers),
    ...Object.values(C)<%- !CLIENT ? '.filter((item) => C.ClientController !== item)' : '' -%>,
    ...(process.env.NODE_ENV !== 'production' ? [DebugController] : []),
  ],
  providers: [
    <% if (CLIENT) { -%>
    GetLocaleUseCase,
    SetLocaleUseCase,
    <% } -%>
    GetMetricsUseCase,
    <% if (CLIENT) { -%>
    {
      provide: ClientGetConfigUseCase,
      useFactory: (repo: ClientRepositoryAdapter) => new ClientGetConfigUseCase(repo),
      inject: [Types.ClientDrivenPort],
    },
    <% } -%>
    {
      provide: InfoGetUseCase,
      useFactory: (repo: InfoRepositoryAdapter) => new InfoGetUseCase(repo),
      inject: [Types.InfoDrivenPort],
    },
    {
      provide: DebugHelloWorldUseCase,
      useFactory: (debug: DebugHttpAdapter) => new DebugHelloWorldUseCase(debug),
      inject: [Types.DebugDrivenPort],
    },
    <% if (!CUT_EXAMPLES) { -%>
    {
      provide: UserCreateUseCase,
      useFactory: (userPort: UserRepositoryAdapter) => new UserCreateUseCase(userPort),
      inject: [Types.UserDrivenPort],
    },
    {
      provide: UserGetUseCase,
      useFactory: (userPort: UserRepositoryAdapter) => new UserGetUseCase(userPort),
      inject: [Types.UserDrivenPort],
    },
    {
      provide: UserListUseCase,
      useFactory: (userPort: UserRepositoryAdapter) => new UserListUseCase(userPort),
      inject: [Types.UserDrivenPort],
    },
    {
      provide: UserUpdateUseCase,
      useFactory: (userPort: UserRepositoryAdapter) => new UserUpdateUseCase(userPort),
      inject: [Types.UserDrivenPort],
    },
    {
      provide: UserReplaceUseCase,
      useFactory: (userPort: UserRepositoryAdapter) => new UserReplaceUseCase(userPort),
      inject: [Types.UserDrivenPort],
    },
    {
      provide: UserDeleteUseCase,
      useFactory: (userPort: UserRepositoryAdapter) => new UserDeleteUseCase(userPort),
      inject: [Types.UserDrivenPort],
    },
    <% } -%>
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
