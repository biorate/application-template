---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/common/unit-spec.ts`) %>
unless_exists: true
---
import { Spec } from '@biorate/vitest-spec';

export abstract class UnitSpec extends Spec {
  protected get httpServer() {
    return null;
  }
}
