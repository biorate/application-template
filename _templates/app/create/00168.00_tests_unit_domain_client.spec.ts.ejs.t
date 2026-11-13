---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/unit/domain/client.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect } from 'vitest';
import { ClientConfig } from '@/app/domain';
import { UnitSpec } from '../../common/unit-spec';

@suite('domain/ClientConfig', { mode: 'parallel' })
class ClientConfigSpec extends UnitSpec {
  @test('creates with given values')
  protected creates() {
    const config = new ClientConfig({ ENV: 'test', version: '1.0.0' });
    expect(config.ENV).toBe('test');
    expect(config.version).toBe('1.0.0');
  }
}
