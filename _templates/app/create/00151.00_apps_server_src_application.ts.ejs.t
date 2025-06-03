---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/application.ts`) %>
unless_exists: true
---
import * as helmet from 'helmet';
import * as cookieParser from 'cookie-parser';
import * as favicon from 'serve-favicon';
import { Server } from 'http';
import { AddressInfo } from 'net';
import { promisify } from 'util';
import { urlencoded, json, Request, Response } from 'express';
import { init, kill, injectable, inject, Types } from '@biorate/inversion';
import { INestApplication, ValidationPipe } from '@nestjs/common';
<%- ADD_WEB_SOCKET ? "import { WsAdapter } from '@nestjs/platform-ws';" : '' -%>
import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
<%- ADD_WEB_SOCKET ? "import { AsyncApiDocumentBuilder, AsyncApiModule } from 'nestjs-asyncapi';" : '' -%>
import { IConfig } from '@biorate/config';
import { path } from '@biorate/tools';
import {
  RoutesInterceptor,
  <% if (!CUT_EXAMPLES) { -%>
  // ProxyPrometheusMiddleware,
  <% } -%>
  AllExceptionsFilter,
} from '@biorate/nestjs-tools';
import { IApplication } from './common/interfaces';
import { Logger } from './logger';
import { AppModule } from './app';

@injectable()
export class Application implements IApplication<Server> {
  @inject(Types.Config) private config: IConfig;

  public app: INestApplication<Server>;

  protected host: string;

  protected port: number;

  @kill() protected async kill() {
    if (!this.app?.getHttpServer) return;
    const server = this.app.getHttpServer();
    await promisify(server.close.bind(server))();
  }

  @init() protected async initialize() {
    this.host = this.config.get<string>('app.host', '0.0.0.0');
    this.port = this.config.get<number>('app.port', 3000);
    this.app = await NestFactory.create(AppModule, { logger: new Logger() });
    <%- ADD_WEB_SOCKET ? "this.app.useWebSocketAdapter(new WsAdapter(this.app));" : '' -%>
    this.app.setGlobalPrefix(this.config.get<string>('app.globalPrefix', ''), {
      exclude: [],
    });
    this.app.useGlobalFilters(new AllExceptionsFilter());
    this.app.useGlobalInterceptors(new RoutesInterceptor());
    this.app.useGlobalPipes(new ValidationPipe({ transform: true }));
    this.app.use(
      helmet(
        this.config.get<unknown>('app.middleware.helmet', {
          contentSecurityPolicy: false,
        }),
      ),
    );
    this.app.use(favicon(path.create(process.cwd(), 'favicon.ico')));
    <% if (!CUT_EXAMPLES) { -%>
    // This is just an example of using a proxy, remove it in production.
    /*
    this.app.use(
     '/yandex',
     ProxyPrometheusMiddleware.create({
        target: this.config.get<string>('Common.url.yandex', 'https://ya.ru'),
        pathRewrite: {
          '^/yandex': '/',
        },
        changeOrigin: true,
      }),
    );
    */
    <% } -%>
    this.app.use(
      json(this.config.get<unknown>('app.middleware.json', { limit: '100mb' })),
    );
    this.app.use(
      urlencoded(
        this.config.get<unknown>('app.middleware.urlencoded', {
          extended: true,
          limit: '100mb',
        }),
      ),
    );
    this.app.use(cookieParser());
    this.app.enableShutdownHooks();
    this.app.enableCors({
      credentials: true,
      origin: (origin, callback) => callback(null, origin),
    });
    this.createSwagger();
    <%- ADD_WEB_SOCKET ? "await this.createAsyncApi();" : '' -%>
    await this.app.listen(this.port, this.host, () => {
      const { address, port } = <AddressInfo>this.app.getHttpServer().address();
      console.info(`Server listen on ${address}:${port}`);
    });
  }

  private createSwagger() {
    const route = this.config.get<string>(
      'app.swagger.routes.documentation',
      '/swagger/json',
    );
    const document = SwaggerModule.createDocument(
      this.app,
      new DocumentBuilder()
        .setTitle(this.config.get<string>('package.name'))
        .setDescription(this.createDescription(route, 'OpenAPI JSON config'))
        .setVersion(this.config.get<string>('package.version'))
        .build(),
    );
    SwaggerModule.setup(
      this.config.get<string>('app.swagger.routes.ui', 'swagger'),
      this.app,
      document,
    );
    this.app.use(route, (req: Request, res: Response) =>
      res.end(JSON.stringify(document)),
    );
  }

  <% if (ADD_WEB_SOCKET) { -%>
  private async createAsyncApi() {
    const route = this.config.get<string>(
      'app.swagger.routes.documentation',
      '/asyncapi/json',
    );
    const servers = this.config.get<{ name: string; protocol: string; url: string }[]>(
      'app.asyncapi.servers',
      [
        {
          name: 'websocket',
          protocol: 'websocket',
          url: `ws://${this.host}:${this.port}`,
        },
      ],
    );
    const builder = new AsyncApiDocumentBuilder()
      .setTitle(this.config.get<string>('package.name'))
      .setDescription(this.createDescription(route, 'AsyncAPI JSON config'))
      .setVersion(this.config.get<string>('package.version'))
      .setDefaultContentType('application/json');
    for (const server of servers)
      builder.addServer(server.name, { url: server.url, protocol: server.protocol });
    const document = AsyncApiModule.createDocument(this.app, builder.build());
    await AsyncApiModule.setup(
      this.config.get<string>('app.asyncapi.routes.ui', 'async-api'),
      this.app,
      document,
    );
    this.app.use(route, (req: Request, res: Response) =>
      res.end(JSON.stringify(document)),
    );
  }
  <% } -%>

  private createDescription(route: string, description: string) {
    return (
      this.config.get<string>('package.description') +
      `<br/><br/><a target="_blank" href="${route}">${description}</a>`
    );
  }
}
