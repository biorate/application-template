<style scoped>
.app {
  font-size: 30px;
}
</style>

<template>
  <div>Page1</div>
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
    setInterval(() => this.store.state.increment(), 1000);
  }

  public mounted() {}

  public updated() {}
}
</script>
