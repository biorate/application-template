---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/unit/persistence/info.repository.adapter.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect } from 'vitest';
import { InfoRepositoryAdapter } from '@/app/infrastructure/persistence';
import { UnitSpec } from '../../common/unit-spec';

@suite('InfoRepositoryAdapter (unit)', { mode: 'parallel' })
class InfoRepositoryAdapterSpec extends UnitSpec {
  @test('getInfo returns Info from config')
  protected async getInfo() {
    const adapter = new InfoRepositoryAdapter();
    (adapter as unknown as { config: { get: (key: string, def?: string) => string | undefined } }).config = {
      get: (key: string, def?: string) => {
        if (key === 'package.name') return 'test-app';
        if (key === 'package.version') return '2.0.0';
        return def;
      },
    };
    const info = await adapter.getInfo();
    expect(info.name).toBe('test-app');
    expect(info.version).toBe('2.0.0');
    expect(info.ENV).toBe('debug');
  }
}
