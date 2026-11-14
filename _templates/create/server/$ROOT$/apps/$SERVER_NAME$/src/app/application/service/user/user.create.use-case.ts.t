---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { User } from '@/app/domain';
import { UserDrivenPort } from '@/app/application/port';

export class UserCreateUseCase {
  public constructor(protected readonly userProvider: UserDrivenPort) {}

  public async execute(user: User) {
    return this.userProvider.create(user);
  }
}
