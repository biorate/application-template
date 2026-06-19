---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/tests/unit/application/user.create.use-case.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect, vi } from 'vitest';
import { UserCreateUseCase } from '@/app/application/service';
import type { UserDrivenPort } from '@/app/application/port';
import { User } from '@/app/domain';
import { UnitSpec } from '../../common/unit-spec';

@suite('UserCreateUseCase', { mode: 'parallel' })
class UserCreateUseCaseSpec extends UnitSpec {
  @test('creates user and returns it')
  protected async execute() {
    const expected = new User({ id: 1, name: 'John', email: 'john@test.com' });
    const userPort: UserDrivenPort = {
      create: vi.fn().mockResolvedValue(expected),
      findOne: vi.fn(),
      find: vi.fn(),
      update: vi.fn(),
      delete: vi.fn(),
      replace: vi.fn(),
    };
    const useCase = new UserCreateUseCase(userPort);
    const result = await useCase.execute(expected);
    expect(userPort.create).toHaveBeenCalledTimes(1);
    expect(userPort.create).toHaveBeenCalledWith(expected);
    expect(result).toEqual(expected);
  }
}
