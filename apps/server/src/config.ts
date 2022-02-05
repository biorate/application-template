import { container, inject, Core, Types } from '@biorate/inversion';
import { IConfig } from '@biorate/config';
import { IPrometheus, Prometheus } from '@biorate/prometheus';
import { FileConfig } from '@biorate/file-config';
import { Application } from './application';
import { IApplication } from './interfaces';

export class Root extends Core() {
  @inject(Types.Config) public config: IConfig;
  @inject(Types.Prometheus) public prometheus: IPrometheus;
  @inject(Types.Application) public application: IApplication;
}
container.bind<IConfig>(Types.Config).to(FileConfig).inSingletonScope();
container.bind<IPrometheus>(Types.Prometheus).to(Prometheus).inSingletonScope();
container.bind<IApplication>(Types.Application).to(Application).inSingletonScope();
container.bind<Root>(Root).toSelf().inSingletonScope();
