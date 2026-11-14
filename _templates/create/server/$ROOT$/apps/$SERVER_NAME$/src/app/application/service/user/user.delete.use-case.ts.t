---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { UserDrivenPort } from '@/app/application/port';

export class UserDeleteUseCase {
  public constructor(protected readonly userProvider: UserDrivenPort) {}

  public async execute(id: number) {
    return this.userProvider.delete(id);
  }
}
