import { MutationTree } from 'vuex';

export namespace IStore {
  export interface IStoreBase<T> {
    mutations?: MutationTree<T>;
  }

  export interface IHello extends IStoreBase<IHello> {
    world: number;
    increment(): void;
  }
}
