import { init, injectable, inject, Types } from '@biorate/inversion';
import { createApp } from 'vue';
import { createRouter, createWebHashHistory } from 'vue-router';
import { createStore } from 'vuex';
import { Test } from './components';
import { App, Page1, Page2 } from './containers';
import { IView, IStore } from '../interfaces';
import { getActions, getMutations } from '../store/decorators';

@injectable()
export class View implements IView {
  @inject(Types.Hello) protected hello: IStore.IHello;

  @init() protected initialize() {
    createApp(App)
      .component('Test', Test)
      .use(
        createRouter({
          history: createWebHashHistory(),
          routes: [
            { path: '/', component: Page1 },
            { path: '/page1', component: Page1 },
            { path: '/page2', component: Page2 },
          ],
        }),
      )
      .use(
        createStore<IStore.IHello>({
          state: this.hello,
          mutations: getMutations(this.hello),
          actions: getActions(this.hello),
        }),
        Types.Hello,
      )
      .mount('#root');
  }
}
