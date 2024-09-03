# Коннектор minio (S3)

Здесть - TODO и RAW example...

```ts
import { inject, container, Types, Core } from '@biorate/inversion';
import { IConfig, Config } from '@biorate/config';
import { MinioConnector, MinioConfig } from '@biorate/minio';

class Root extends Core() {
  @inject(MinioConnector) public connector: MinioConnector;
}

container.bind<IConfig>(Types.Config).to(Config).inSingletonScope();
container.bind<MinioConnector>(MinioConnector).toSelf().inSingletonScope();
container.bind<Root>(Root).toSelf().inSingletonScope();

container.get<IConfig>(Types.Config).merge({
  Minio: [
    {
      name: 'connection',
      options: {
        endPoint: 'localhost',
        port: 9000,
        accessKey: 'admin',
        secretKey: 'minioadmin',
        useSSL: false,
      },
    },
  ],
});

(async () => {
  const root = container.get<Root>(Root);
  await root.$run();
  await root.connector!.current!.makeBucket('test', 'test');
  await root.connector!.current!.putObject(
    'test',
    'hello.world',
    Buffer.from('Hello world!'),
  ));
  root.connector!.current!.getObject('test', 'test.file', (e, stream) => {
    let data = '';
    stream
      .on('data', (chunk) => (data += chunk.length))
      .on('end', () => console.log(data)); // 'Hello world!'
   });
})();
```


