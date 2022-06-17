<style scoped>
.app {
  font-size: 30px;
}
</style>

<template>
  <router-view></router-view>
  <div class="app">{{ hello }}</div>
  <div>{{ store.state.foo }}</div>
  <div>{{ store.state.bar }}</div>
  <Test string="world" :number="store.state.world" />
</template>

<script lang="ts">
import { Provide, Vue } from 'vue-property-decorator';
import { useStore } from 'vuex';
import { IStore } from '../../interfaces';
import { Types } from '@biorate/inversion';

export default class App extends Vue {
  protected store = useStore<IStore.IHello>(Types.Hello);

  @Provide() protected hello = 'hello';

  public created() {
    setInterval(() => this.store.dispatch('increment'), 1000);
  }

  public mounted() {}

  public updated() {}
}
</script>
