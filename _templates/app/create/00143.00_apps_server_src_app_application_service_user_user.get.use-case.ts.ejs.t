---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/src/app/application/service/user/user.get.use-case.ts`) %>
unless_exists: true
---
import { UserDrivenPort } from '@/app/application/port';

export class UserGetUseCase {
  public constructor(protected readonly userProvider: UserDrivenPort) {}

  public async execute(id: number) {
    return this.userProvider.findOne(id);
  }
}
