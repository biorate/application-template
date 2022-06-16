import { injectable, inject, Types } from '@biorate/inversion';
import { Hello } from './hello';

@injectable()
export class Store {
  @inject(Types.Hello) public hello: Hello;
}

export { Hello } from './hello';
