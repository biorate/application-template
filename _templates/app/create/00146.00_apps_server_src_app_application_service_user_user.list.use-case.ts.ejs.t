---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/src/app/application/service/user/user.list.use-case.ts`) %>
unless_exists: true
---
import { UserDrivenPort } from '@/app/application/port';

export class UserListUseCase {
  public constructor(protected readonly userProvider: UserDrivenPort) {}

  public async execute(offset = 0, limit = 100) {
    return this.userProvider.find(offset, limit);
  }
}
