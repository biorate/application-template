---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/src/app/application/service/user/user.list.use-case.ts`) %>
unless_exists: true
---
import { Inject, Injectable } from '@nestjs/common';
import { Types } from '@biorate/inversion';
import { UserProviderPort } from '../../ports';

@Injectable()
export class UserListUseCase {
  @Inject(Types.UserProviderPort)
  protected readonly userProvider: UserProviderPort;

  public async execute(offset = 0, limit = 100) {
    return this.userProvider.find(offset, limit);
  }
}
