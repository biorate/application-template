---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/src/test.ts`) %>
unless_exists: true
---
import { injectable } from '@biorate/inversion';

@injectable()
export class Test {
  protected inc = 2;

  protected dec = 1;

  public echo() {
    return 'hello';
  }

  protected mutate(object: { inc: number }) {
    this.inc += object.inc;
    object.inc++;
    return this.inc;
  }

  protected error() {
    throw new Error('test-error');
  }
}
