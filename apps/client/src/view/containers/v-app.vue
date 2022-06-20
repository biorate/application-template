<style scoped>
.container {
  width: 100%;
  height: 300px;
  background: gray;
}

.box {
  width: 100px;
  height: 100px;
  background: green;
}
</style>

<template>
  <router-view></router-view>
  <v-flex class="container" around middle>
    <v-flex center middle class="box">{{ hello }}</v-flex>
    <v-flex center middle class="box">{{ store.state.world }}</v-flex>
    <v-flex center middle class="box">{{ $t('привет') }}</v-flex>
  </v-flex>
</template>

<script lang="ts">
import { Provide, Vue } from 'vue-property-decorator';
import { useStore } from 'vuex';
import { Types } from '@biorate/inversion';
import { IStore } from '../../interfaces';

export default class App extends Vue {
  protected store = useStore<IStore.IHello>(Types.Hello);

  @Provide() protected hello = 'hello';

  public created() {
    setInterval(
      () => this.store.commit('set', { world: this.store.state.world + 1 }),
      1000,
    );
  }

  public mounted() {}

  public updated() {}
}
</script>
