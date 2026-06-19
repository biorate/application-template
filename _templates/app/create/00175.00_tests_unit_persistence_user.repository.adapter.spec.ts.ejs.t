---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/tests/unit/persistence/user.repository.adapter.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect } from 'vitest';
import { UserRepositoryAdapter } from '@/app/infrastructure/persistence';
import { User } from '@/app/domain';
import { UserAlreadyExistsError, UserNotExistsError } from '@/app/domain/error';
import { UnitSpec } from '../../common/unit-spec';

@suite('UserRepositoryAdapter (unit)', { mode: 'parallel' })
class UserRepositoryAdapterSpec extends UnitSpec {
  @test('findOne returns user by id')
  protected async findOne() {
    const adapter = new UserRepositoryAdapter();
    const user = await adapter.findOne(1);
    expect(user).toBeInstanceOf(User);
    expect(user!.id).toBe(1);
    expect(user!.name).toBe('Bob');
  }

  @test('findOne returns undefined for missing id')
  protected async findOneMissing() {
    const adapter = new UserRepositoryAdapter();
    const user = await adapter.findOne(999);
    expect(user).toBeUndefined();
  }

  @test('find returns paginated slice')
  protected async findPaginated() {
    const adapter = new UserRepositoryAdapter();
    const users = await adapter.find(0, 1);
    expect(users).toHaveLength(1);
    expect(users[0]!.id).toBe(1);
  }

  @test('create adds a new user')
  protected async create() {
    const adapter = new UserRepositoryAdapter();
    const user = new User({ id: 3, name: 'Charlie', email: 'charlie@test.com' });
    const created = await adapter.create(user);
    expect(created).toBeInstanceOf(User);
    expect(created!.id).toBe(3);
    expect(created!.name).toBe('Charlie');
  }

  @test('create throws UserAlreadyExistsError for duplicate id')
  protected async createDuplicate() {
    const adapter = new UserRepositoryAdapter();
    const user = new User({ id: 1, name: 'Duplicate' });
    await expect(adapter.create(user)).rejects.toThrow(UserAlreadyExistsError);
  }

  @test('update modifies existing user')
  protected async update() {
    const adapter = new UserRepositoryAdapter();
    const user = new User({ id: 1, name: 'Updated Bob' });
    const updated = await adapter.update(user);
    expect(updated!.name).toBe('Updated Bob');
  }

  @test('update throws UserNotExistsError for missing user')
  protected async updateMissing() {
    const adapter = new UserRepositoryAdapter();
    const user = new User({ id: 999, name: 'Ghost' });
    await expect(adapter.update(user)).rejects.toThrow(UserNotExistsError);
  }

  @test('delete removes existing user')
  protected async delete() {
    const adapter = new UserRepositoryAdapter();
    await adapter.delete(1);
    const user = await adapter.findOne(1);
    expect(user).toBeUndefined();
  }

  @test('delete throws UserNotExistsError for missing user')
  protected async deleteMissing() {
    const adapter = new UserRepositoryAdapter();
    await expect(adapter.delete(999)).rejects.toThrow(UserNotExistsError);
  }

  @test('replace swaps existing user')
  protected async replace() {
    const adapter = new UserRepositoryAdapter();
    const user = new User({ id: 1, name: 'Replaced', email: 'replaced@test.com' });
    const replaced = await adapter.replace(user);
    expect(replaced).toBeInstanceOf(User);
    expect(replaced!.name).toBe('Replaced');
  }

  @test('replace throws UserNotExistsError for missing user')
  protected async replaceMissing() {
    const adapter = new UserRepositoryAdapter();
    const user = new User({ id: 999, name: 'Ghost' });
    await expect(adapter.replace(user)).rejects.toThrow(UserNotExistsError);
  }
}
