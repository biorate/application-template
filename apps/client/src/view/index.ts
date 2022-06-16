import { init, injectable, inject, Types } from '@biorate/inversion';
import { createApp } from 'vue';
import { createStore } from 'vuex';
import { Hello } from '../store';
import App from './App.vue';
import Test from './Test.vue';

@injectable()
export class View {
  @inject(Types.Hello) protected hello: Hello;

  @init() protected initialize() {
    createApp(App)
      .component('Test', Test)
      .use(
        createStore<Hello>({
          state: this.hello,
        }),
        Types.Hello,
      )
      .mount('#root');
  }
}
