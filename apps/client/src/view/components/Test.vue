<style scoped>
.number {
  font-size: 30px;
}

.string {
  font-size: 20px;
}
</style>

<template>
  <div class="number">{{ number }}</div>
  <div class="string">{{ string }}</div>
</template>

<script lang="ts">
import { Vue, Prop } from 'vue-property-decorator';

export default class Test extends Vue {
  @Prop({ default: 10, type: Number }) protected readonly number: number;
  @Prop({ required: true, type: String }) protected readonly string: string;
}
</script>
