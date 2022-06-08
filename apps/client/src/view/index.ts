import { init, injectable, Types } from '@biorate/inversion';
import { createApp } from 'vue';
import { createStore } from 'vuex';
import App from './App.vue';

class A {
  a = 1;
}

class B extends A {
  b = 222;
  arr = [1, 2, 3];

  action() {
    ++this.arr[1];
    ++this.arr[2];
  }

  actionB() {
    ++this.b;
  }
}

@injectable()
export class View {
  @init() protected initialize() {
    createApp(App)
      .use(
        createStore<B>({
          state: new B(),
        }),
        Types.Store,
      )
      // .use(
      //   createStore<A>({
      //     state: new A(),
      //   }),
      //   key2,
      // )
      .mount('#root');
  }
}
