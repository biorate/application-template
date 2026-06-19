---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/unit/http/info.controller.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect, vi } from 'vitest';
import { InfoController } from '@/app/infrastructure/http/in/info.controller';
import { InfoGetUseCase } from '@/app/application/service';
import { UnitSpec } from '../../common/unit-spec';

class TestInfoController extends InfoController {
  public callGet() {
    return this.get();
  }
}

@suite('InfoController (unit)', { mode: 'parallel' })
class InfoControllerSpec extends UnitSpec {
  @test('delegates to use case and returns its result')
  protected async get() {
    const expected = { name: 'app', version: '1.0.0', ENV: 'test' };
    const execute = vi.fn().mockResolvedValue(expected);
    const infoGet = { execute } as unknown as InfoGetUseCase;
    const controller = new TestInfoController(infoGet);
    const result = await controller.callGet();
    expect(execute).toHaveBeenCalledTimes(1);
    expect(result).toBe(expected);
  }
}
