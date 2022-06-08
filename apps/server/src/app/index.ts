import { join } from 'path';
import { Module, MiddlewareConsumer } from '@nestjs/common';
import { ServeStaticModule } from '@nestjs/serve-static';
import { APP_GUARD } from '@nestjs/core';
import { GraphQLModule } from '@nestjs/graphql';
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo';
import { RolesGuard } from './providers';
import { Users } from './resolvers';
import { ResponseTime } from './middlewares/response-time';
import { RequestCount } from './middlewares/request-count';
import { ProbeController } from './controllers/probe';
import { MetricsController } from './controllers/metrics';

@Module({
  imports: [
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      debug: true,
      playground: true,
      autoSchemaFile: 'schema.gql',
    }),
    ServeStaticModule.forRoot({
      rootPath: join(process.cwd(), '../client/dist'),
    }),
  ],
  controllers: [ProbeController, MetricsController],
  providers: [
    {
      provide: APP_GUARD,
      useClass: RolesGuard,
    },
    Users,
  ],
})
export class AppModule {
  public configure(consumer: MiddlewareConsumer) {
    consumer.apply(ResponseTime).forRoutes('*');
    consumer.apply(RequestCount).forRoutes('*');
  }
}
