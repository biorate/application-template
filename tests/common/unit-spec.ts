import { Spec } from '@biorate/vitest-spec';

/**
 * База для unit-тестов: приложение/HTTP-сервер не поднимается.
 */
export abstract class UnitSpec extends Spec {
  protected get httpServer() {
    return null;
  }
}
