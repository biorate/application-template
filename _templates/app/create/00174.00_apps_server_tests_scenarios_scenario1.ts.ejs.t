---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/tests/scenarios/scenario1.ts`) %>
unless_exists: true
---
import { Step, Scenario } from '@biorate/vitest';

export class Scenario1 extends Scenario {
  @Step()
  protected async step1() {
    this.ctx.set('a', 1);
  }

  @Step()
  protected async step2() {
    this.ctx.set('b', 2);
  }
}
