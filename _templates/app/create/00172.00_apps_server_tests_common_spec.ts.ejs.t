---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/common/spec.ts`) %>
unless_exists: true
---
import { container } from '@biorate/inversion';
import { Spec as CommonSpec } from '@biorate/vitest-spec';
import { Root } from '../../src/app/infrastructure/bootstrap/root-config';

export abstract class Spec extends CommonSpec {
  protected root: Root = container.get<Root>(Root);

  protected get httpServer() {
    return this.root.application.app.getHttpServer();
  }
}
