---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/src/app/application/service/user/user.update.use-case.ts`) %>
unless_exists: true
---
import { Inject, Injectable } from '@nestjs/common';
import { Types } from '@biorate/inversion';
import { User } from '../../../domain/';
import { UserProviderPort } from '../../ports';

@Injectable()
export class UserUpdateUseCase {
  @Inject(Types.UserProviderPort)
  protected readonly userProvider: UserProviderPort;

  public async execute(user: User) {
    return this.userProvider.update(user);
  }
}
