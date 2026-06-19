---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/unit/domain/info.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect } from 'vitest';
import { Info } from '@/app/domain';
import { UnitSpec } from '../../common/unit-spec';

@suite('domain/Info', { mode: 'parallel' })
class InfoSpec extends UnitSpec {
  @test('creates with given values')
  protected creates() {
    const info = new Info({ name: 'app', version: '1.0.0', ENV: 'test' });
    expect(info.name).toBe('app');
    expect(info.version).toBe('1.0.0');
    expect(info.ENV).toBe('test');
  }
}
