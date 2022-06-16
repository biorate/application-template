import { container, inject, Core, Types, init, kill } from '@biorate/inversion';
import { Hello } from './store';
import { View } from './view';
import { IView, IStore } from './interfaces';

export class Root extends Core() {
  @inject(Types.View) protected view: IView;

  @init() protected initialize() {
    console.info('Application ready');
  }

  @kill() protected destruct() {
    console.info('Application shutdown');
  }
}

container.bind<IView>(Types.View).to(View).inSingletonScope();
container.bind<IStore.IHello>(Types.Hello).to(Hello).inSingletonScope();
container.bind<Root>(Root).toSelf().inSingletonScope();
