import { container, inject, Core, Types } from '@biorate/inversion';
import { IConfig } from '@biorate/config';
import { Store, Hello, Websocket, Config, Preloader } from './store';

export class Root extends Core() {
  @inject(Types.Store) protected store: Store;
}

container.bind<IConfig>(Types.Config).to(Config).inSingletonScope();
container.bind<Store>(Types.Store).to(Store).inSingletonScope();
container.bind<Hello>(Types.Hello).to(Hello).inSingletonScope();
container.bind<Websocket>(Types.Websocket).to(Websocket).inSingletonScope();
container.bind<Preloader>(Types.Preloader).to(Preloader).inSingletonScope();
container.bind<Root>(Root).toSelf().inSingletonScope();
