<style scoped>
.app {
  font-size: 30px;
}
</style>

<template>
  <div class="app">{{ hello }}</div>
  <Test string="world" :number="store.state.world" />
</template>

<script lang="ts">
import { useStore } from 'vuex';
import { Vue, Provide } from 'vue-property-decorator';
import { Types } from '@biorate/inversion';
import { IStore } from '../../interfaces';

export default class App extends Vue {
  protected store = useStore<IStore.IHello>(Types.Hello);

  @Provide() protected hello = 'hello';

  public created() {
    setInterval(() => ++this.store.state.world, 1000);
  }

  public mounted() {}
}
</script>
