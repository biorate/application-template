---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/src/app/application/service/user/user.replace.use-case.ts`) %>
unless_exists: true
---
import { User } from '@/app/domain';
import { UserDrivenPort } from '@/app/application/port';

export class UserReplaceUseCase {
  public constructor(protected readonly userProvider: UserDrivenPort) {}

  public async execute(user: User) {
    return this.userProvider.replace(user);
  }
}
