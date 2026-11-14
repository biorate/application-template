---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
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
