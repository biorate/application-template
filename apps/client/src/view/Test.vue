<style scoped>
.test {
  font-size: 30px;
}
</style>

<template>
  <div class="test">{{ propA }}</div>
</template>

<script lang="ts">
import { Vue, Prop, Provide } from 'vue-property-decorator';

export default class Test extends Vue {
  @Prop({
    required: true,
    type: Number,
  })
  protected readonly propA: number;

  public created() {
    console.log(this.propA);
  }
}
</script>
