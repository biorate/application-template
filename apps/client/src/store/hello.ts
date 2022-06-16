import { injectable, init } from '@biorate/inversion';

@injectable()
export class Hello {
  public blast = 1;
  public world = 0;

  @init() protected initialize() {
    // setInterval(() => ++this.world, 1000);
    // setInterval(() => ++this.blast, 1000);
  }
}
