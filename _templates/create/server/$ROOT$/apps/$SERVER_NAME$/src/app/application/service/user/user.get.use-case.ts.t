---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { UserDrivenPort } from '@/app/application/port';

export class UserGetUseCase {
  public constructor(protected readonly userProvider: UserDrivenPort) {}

  public async execute(id: number) {
    return this.userProvider.findOne(id);
  }
}
