---
unless_exists: true
mirror: true
---
import { container } from '@biorate/inversion';
import { Spec } from '@biorate/vitest-spec';
import { Root } from '@/app/infrastructure/bootstrap';

export abstract class CommonSpec extends Spec {
  protected root: Root = container.get<Root>(Root);

  protected get httpServer() {
    return this.root.application.app.getHttpServer();
  }
}
