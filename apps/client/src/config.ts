import { container, inject, Core, Types } from '@biorate/inversion';
import { Store, Hello, Router } from './store';
import { View } from './view';

export class Root extends Core() {
  @inject(Types.Store) protected store: Store;

  @inject(Types.View) protected view: View;
}

container.bind<Store>(Types.Store).to(Store).inSingletonScope();
container.bind<View>(Types.View).to(View).inSingletonScope();
container.bind<Hello>(Types.Hello).to(Hello).inSingletonScope();
container.bind<Router>(Types.Router).to(Router).inSingletonScope();
container.bind<Root>(Root).toSelf().inSingletonScope();
