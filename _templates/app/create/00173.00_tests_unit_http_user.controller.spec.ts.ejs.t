---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/tests/unit/http/user.controller.spec.ts`) %>
unless_exists: true
---
import { suite, test } from '@biorate/vitest';
import { expect, vi } from 'vitest';
import { UserController } from '@/app/infrastructure/http/in/user.controller';
import {
  UserCreateUseCase,
  UserGetUseCase,
  UserListUseCase,
  UserUpdateUseCase,
  UserReplaceUseCase,
  UserDeleteUseCase,
} from '@/app/application/service';
import { User } from '@/app/domain';
import { UnitSpec } from '../../common/unit-spec';

class TestUserController extends UserController {
  public callGetList(query: { offset: number; limit: number }) {
    return this.get(query as never);
  }

  public callGetOne(params: { id: number }) {
    return this.list(params as never);
  }

  public callCreate(body: Record<string, unknown>) {
    return this.create(body as never);
  }

  public callDelete(params: { id: number }) {
    return this.delete(params as never);
  }

  public callReplace(params: { id: number }, body: Record<string, unknown>) {
    return this.replace(params as never, body as never);
  }

  public callUpdate(params: { id: number }, body: Record<string, unknown>) {
    return this.update(params as never, body as never);
  }
}

@suite('UserController (unit)', { mode: 'parallel' })
class UserControllerSpec extends UnitSpec {
  @test('GET /user delegates to list use case')
  protected async getList() {
    const users = [new User({ id: 1, name: 'A' })];
    const listUserUseCase = { execute: vi.fn().mockResolvedValue(users) };
    const controller = new TestUserController(
      {} as never,
      {} as never,
      listUserUseCase as unknown as UserListUseCase,
      {} as never,
      {} as never,
      {} as never,
    );
    const result = await controller.callGetList({ offset: 0, limit: 10 });
    expect(listUserUseCase.execute).toHaveBeenCalledWith(0, 10);
    expect(result).toBe(users);
  }

  @test('GET /user/:id delegates to get use case')
  protected async getOne() {
    const user = new User({ id: 5, name: 'Target' });
    const getUserUseCase = { execute: vi.fn().mockResolvedValue(user) };
    const controller = new TestUserController(
      {} as never,
      getUserUseCase as unknown as UserGetUseCase,
      {} as never,
      {} as never,
      {} as never,
      {} as never,
    );
    const result = await controller.callGetOne({ id: 5 });
    expect(getUserUseCase.execute).toHaveBeenCalledWith(5);
    expect(result).toBe(user);
  }

  @test('POST /user delegates to create use case')
  protected async create() {
    const created = new User({ id: 10, name: 'New', email: 'new@test.com' });
    const createUserUseCase = { execute: vi.fn().mockResolvedValue(created) };
    const controller = new TestUserController(
      createUserUseCase as unknown as UserCreateUseCase,
      {} as never,
      {} as never,
      {} as never,
      {} as never,
      {} as never,
    );
    const result = await controller.callCreate({ id: 10, name: 'New', email: 'new@test.com' });
    expect(createUserUseCase.execute).toHaveBeenCalledTimes(1);
    expect(createUserUseCase.execute).toHaveBeenCalledWith(expect.any(User));
    expect(result).toBe(created);
  }

  @test('DELETE /user/:id delegates to delete use case')
  protected async delete() {
    const deleteUserUseCase = { execute: vi.fn().mockResolvedValue(undefined) };
    const controller = new TestUserController(
      {} as never,
      {} as never,
      {} as never,
      {} as never,
      {} as never,
      deleteUserUseCase as unknown as UserDeleteUseCase,
    );
    await controller.callDelete({ id: 3 });
    expect(deleteUserUseCase.execute).toHaveBeenCalledWith(3);
  }

  @test('PUT /user/:id delegates to replace use case')
  protected async replace() {
    const replaced = new User({ id: 1, name: 'Replaced' });
    const replaceUserUseCase = { execute: vi.fn().mockResolvedValue(replaced) };
    const controller = new TestUserController(
      {} as never,
      {} as never,
      {} as never,
      {} as never,
      replaceUserUseCase as unknown as UserReplaceUseCase,
      {} as never,
    );
    const result = await controller.callReplace({ id: 1 }, { name: 'Replaced' });
    expect(replaceUserUseCase.execute).toHaveBeenCalledWith(expect.any(User));
    expect(result).toBe(replaced);
  }

  @test('PATCH /user/:id delegates to update use case')
  protected async update() {
    const updated = new User({ id: 2, name: 'Updated' });
    const updateUserUseCase = { execute: vi.fn().mockResolvedValue(updated) };
    const controller = new TestUserController(
      {} as never,
      {} as never,
      {} as never,
      updateUserUseCase as unknown as UserUpdateUseCase,
      {} as never,
      {} as never,
    );
    const result = await controller.callUpdate({ id: 2 }, { name: 'Updated' });
    expect(updateUserUseCase.execute).toHaveBeenCalledWith(expect.any(User));
    expect(result).toBe(updated);
  }
}
