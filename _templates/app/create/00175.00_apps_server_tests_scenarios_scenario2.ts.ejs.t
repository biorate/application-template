---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/tests/scenarios/scenario2.ts`) %>
unless_exists: true
---
import { Step, Scenario } from '@biorate/vitest';

export class Scenario2 extends Scenario {
  @Step()
  protected async step1() {
    this.ctx.set('c', 3);
  }

  @Step()
  protected async step2() {
    this.ctx.set('d', 4);
  }
}
