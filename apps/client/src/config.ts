import { container, inject, Core, Types, kill } from '@biorate/inversion';
import { Store, Hello } from './store';
import { View } from './view';

export class Root extends Core() {
  @inject(Types.Store) protected store: Store;
  @inject(Types.View) protected view: View;
}

container.bind<Store>(Types.Store).to(Store).inSingletonScope();
container.bind<View>(Types.View).to(View).inSingletonScope();
container.bind<Hello>(Types.Hello).to(Hello).inSingletonScope();
container.bind<Root>(Root).toSelf().inSingletonScope();
