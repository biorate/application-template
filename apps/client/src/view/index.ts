import { init, injectable, inject, Types } from '@biorate/inversion';
import { createApp } from 'vue';
import { createRouter, createWebHashHistory } from 'vue-router';
import { createStore } from 'vuex';
import { Flex } from './components';
import { App, First, Second } from './containers';
import { IView, IStore } from '../interfaces';
import { getActions, getMutations } from '../store/decorators';

@injectable()
export class View implements IView {
  @inject(Types.Hello) protected hello: IStore.IHello;

  @init() protected initialize() {
    createApp(App)
      .component('Flex', Flex)
      .use(
        createRouter({
          history: createWebHashHistory(),
          routes: [
            { path: '/', component: First },
            { path: '/first', component: First },
            { path: '/second', component: Second },
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
