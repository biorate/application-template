---
to: <%= !h.CUT_EXAMPLES && `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/application/port/user.driven.port.ts` %>
unless_exists: true
---
import { User } from '@/app/domain';

export interface UserDrivenPort {
  create(user: User): Promise<User>;

  findOne(id: number): Promise<User | undefined>;

  find(offset: number, limit: number): Promise<User[] | undefined>;

  update(user: User): Promise<User>;

  delete(id: number): Promise<void>;

  replace(user: User): Promise<User>;
}
