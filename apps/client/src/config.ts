import { container, inject, Core, Types, kill } from '@biorate/inversion';
import { Hello } from './store';
import { View } from './view';

export class Root extends Core() {
  @inject(Types.View) protected view: View;
}

container.bind<View>(Types.View).to(View).inSingletonScope();
container.bind<Hello>(Types.Hello).to(Hello).inSingletonScope();
container.bind<Root>(Root).toSelf().inSingletonScope();
