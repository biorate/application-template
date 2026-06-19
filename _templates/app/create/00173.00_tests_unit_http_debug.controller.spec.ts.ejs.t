---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/tests/unit/http/debug.controller.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect, vi } from 'vitest';
import { DebugController } from '@/app/infrastructure/http/in/debug.controller';
import { DebugHelloWorldUseCase } from '@/app/application/service';
import { UnitSpec } from '../../common/unit-spec';

class TestDebugController extends DebugController {
  public callGet() {
    return this.get();
  }
}

@suite('DebugController (unit)', { mode: 'parallel' })
class DebugControllerSpec extends UnitSpec {
  @test('delegates to use case and returns its result')
  protected async get() {
    const execute = vi.fn().mockResolvedValue('dev/test-app:1.0.0 -> "Hello world!"');
    const helloWorld = { execute } as unknown as DebugHelloWorldUseCase;
    const controller = new TestDebugController(helloWorld);
    const result = await controller.callGet();
    expect(execute).toHaveBeenCalledTimes(1);
    expect(result).toBe('dev/test-app:1.0.0 -> "Hello world!"');
  }
}
