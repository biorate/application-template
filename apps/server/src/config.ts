import { container, inject, Core, Types } from '@biorate/inversion';
import { IConfig } from '@biorate/config';
import { FileConfig } from '@biorate/file-config';
import { Application } from './application';
import { IApplication } from './interfaces';

export class Root extends Core() {
  @inject(Types.Config) public config: IConfig;
  @inject(Types.Application) public application: IApplication;
}

container.bind<IConfig>(Types.Config).to(FileConfig).inSingletonScope();
container.bind<IApplication>(Types.Application).to(Application).inSingletonScope();
container.bind<Root>(Root).toSelf().inSingletonScope();
