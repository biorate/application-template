---
to: <%= h.server(CLIENT && `${ROOT}/apps/${SERVER_NAME}/tests/unit/http/client.controller.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect, vi } from 'vitest';
import { ClientController } from '@/app/infrastructure/http/in/client.controller';
import { ClientGetConfigUseCase } from '@/app/application/service';
import { UnitSpec } from '../../common/unit-spec';

class TestClientController extends ClientController {
  public callGet() {
    return this.get();
  }
}

@suite('ClientController (unit)', { mode: 'parallel' })
class ClientControllerSpec extends UnitSpec {
  @test('delegates to use case and returns config')
  protected async get() {
    const expected = { ENV: 'test', version: '1.0.0' };
    const execute = vi.fn().mockResolvedValue(expected);
    const getConfigUseCase = { execute } as unknown as ClientGetConfigUseCase;
    const controller = new TestClientController(
      getConfigUseCase,
      { execute: vi.fn() } as never,
      { execute: vi.fn() } as never,
    );
    const result = await controller.callGet();
    expect(execute).toHaveBeenCalledTimes(1);
    expect(result).toBe(expected);
  }
}
