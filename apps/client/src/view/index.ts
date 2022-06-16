import { init, injectable, inject, Types } from '@biorate/inversion';
import { createApp } from 'vue';
import { createStore } from 'vuex';
import { Hello } from '../store';
import { Test } from './components';
import { App } from './containers';
import { IView } from '../interfaces';

@injectable()
export class View implements IView {
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
