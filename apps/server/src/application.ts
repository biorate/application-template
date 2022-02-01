import * as helmet from 'helmet';
import * as cookieParser from 'cookie-parser';
import { init, injectable, inject, Types } from '@biorate/inversion';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { urlencoded, json } from 'express';
import { AppModule } from './app';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { IConfig } from '@biorate/config';
import { IApplication } from './interfaces';
import { AllExceptionsFilter } from './filters';
import { ResponseInterceptor } from './interceptors';
import { Logger } from './logger';

@injectable()
export class Application implements IApplication {
  @inject(Types.Config) private config: IConfig;
  public app: INestApplication;

  @init() protected async initialize() {
    const host = this.config.get<string>('app.host', '0.0.0.0');
    const port = this.config.get<number>('app.port', 3000);
    this.app = await NestFactory.create(AppModule, { logger: new Logger() });
    this.app.setGlobalPrefix('/api');
    this.app.useGlobalFilters(new AllExceptionsFilter());
    this.app.useGlobalInterceptors(new ResponseInterceptor());
    this.app.useGlobalPipes(new ValidationPipe());
    this.app.use(
      helmet(
        this.config.get<unknown>('app.middleware.helmet', {
          contentSecurityPolicy: false,
        }),
      ),
    );
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
    await this.app.listen(port, host, () => {
      const { address, port } = this.app.getHttpServer().address();
      console.info(`Server listen on ${address}:${port}`);
    });
  }

  private createSwagger() {
    SwaggerModule.setup(
      this.config.get<string>('swagger.route', 'swagger'),
      this.app,
      SwaggerModule.createDocument(
        this.app,
        new DocumentBuilder()
          .setTitle(this.config.get<string>('project'))
          .setDescription(this.config.get<string>('package.description'))
          .setVersion(this.config.get<string>('package.version'))
          .build(),
      ),
    );
  }
}
