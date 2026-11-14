---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { UserDrivenPort } from '@/app/application/port';

export class UserListUseCase {
  public constructor(protected readonly userProvider: UserDrivenPort) {}

  public async execute(offset = 0, limit = 100) {
    return this.userProvider.find(offset, limit);
  }
}
