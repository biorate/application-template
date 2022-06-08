import { injectable, inject, Types } from '@biorate/inversion';
import { Hello } from './hello';
import { Router } from './router';

@injectable()
export class Store {
  @inject(Types.Router) public router: Router;
  @inject(Types.Hello) public hello: Hello;
}

export { Hello } from './hello';
export { Router } from './router';
