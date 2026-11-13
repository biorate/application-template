---
to: <%= !h.CUT_EXAMPLES && `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/application/service/user/user.get.use-case.ts` %>
unless_exists: true
---
import { UserDrivenPort } from '@/app/application/port';

export class UserGetUseCase {
  public constructor(protected readonly userProvider: UserDrivenPort) {}

  public async execute(id: number) {
    return this.userProvider.findOne(id);
  }
}
