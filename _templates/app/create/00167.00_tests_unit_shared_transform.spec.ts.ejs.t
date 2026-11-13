---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/unit/shared/transform.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect } from 'vitest';
import { toInt, toBool } from '@/app/infrastructure/shared/transform';
import { UnitSpec } from '../../common/unit-spec';

@suite('shared/transform', { mode: 'parallel' })
class TransformSpec extends UnitSpec {
  @test('toInt parses integer values')
  protected toIntParses() {
    const obj: Record<string, unknown> = { n: '42' };
    toInt({ obj, key: 'n' });
    expect(obj.n).toBe(42);
  }

  @test('toInt stores NaN when value is not a number')
  protected toIntNaN() {
    const obj: Record<string, unknown> = { n: 'nope' };
    toInt({ obj, key: 'n' });
    expect(Number.isNaN(obj.n)).toBe(true);
  }

  @test('toBool converts "true" to boolean true')
  protected toBoolTrue() {
    const obj: Record<string, unknown> = { b: 'true' };
    toBool({ obj, key: 'b' });
    expect(obj.b).toBe(true);
  }

  @test('toBool converts any other value to boolean false')
  protected toBoolFalse() {
    const obj: Record<string, unknown> = { b: 'false' };
    toBool({ obj, key: 'b' });
    expect(obj.b).toBe(false);
  }
}
