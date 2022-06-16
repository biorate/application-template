import { InjectionKey } from 'vue';
import { createStore, useStore as baseUseStore, Store } from 'vuex';

// class State {
//   public count = 1;
// }

// define your own `useStore` composition function
// export function useStore() {
//   return baseUseStore(key);
// }

export function create<T>(symbol: symbol, state: T) {
  return {
    key: <InjectionKey<Store<T>>>symbol,
    store: createStore<T>({ state }),
  };
}
