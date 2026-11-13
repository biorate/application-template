---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/tests/unit/domain/user.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect } from 'vitest';
import { User } from '@/app/domain';
import { UnitSpec } from '../../common/unit-spec';

@suite('domain/User', { mode: 'parallel' })
class UserSpec extends UnitSpec {
  @test('creates with all fields')
  protected creates() {
    const user = new User({ id: 1, name: 'John', email: 'john@test.com' });
    expect(user.id).toBe(1);
    expect(user.name).toBe('John');
    expect(user.email).toBe('john@test.com');
  }

  @test('creates with optional fields omitted')
  protected createsMinimal() {
    const user = new User({ id: 2 });
    expect(user.id).toBe(2);
    expect(user.name).toBeUndefined();
    expect(user.email).toBeUndefined();
  }

  @test('creates with nested address')
  protected createsWithAddress() {
    const user = new User({
      id: 3,
      address: { city: 'NYC', street: 'Broadway', apartment: 12, postal: 10001 },
    });
    expect(user.address).toBeDefined();
    expect(user.address!.inline).toBe('10001, NYC, Broadway №12');
  }
}
