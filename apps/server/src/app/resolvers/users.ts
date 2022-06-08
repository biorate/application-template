import { User } from '../models';
import { Resolver, Int, Args, Query } from '@nestjs/graphql';

@Resolver((of) => User)
export class Users {
  @Query((returns) => User)
  protected async users(@Args('id', { type: () => Int }) id: number) {
    const user = new User();
    user.id = id;
    user.name = 'test';
    return user;
  }
}
