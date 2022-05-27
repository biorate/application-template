import { init, injectable } from '@biorate/inversion';
import { createApp } from 'vue';
import { createStore } from 'vuex';
import App from './App.vue';

class A {
  a = 1;
}
class B extends A {
  b = 2;

  action() {
    ++this.b;
  }
}

@injectable()
export class View {
  @init() protected initialize() {
    createApp(App)
      .use(
        createStore({
          state: new B(),
        }),
      )
      .mount('#root');
  }
}
