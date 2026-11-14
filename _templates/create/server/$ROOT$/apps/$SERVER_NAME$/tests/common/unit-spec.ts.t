---
unless_exists: true
mirror: true
---
import { Spec } from '@biorate/vitest-spec';

export abstract class UnitSpec extends Spec {
  protected get httpServer() {
    return null;
  }
}
