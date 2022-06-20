<style scoped>
.page {
  user-select: none;
  background: azure;
  width: 100%;
  height: 100px;
}
</style>

<template>
  <v-flex center middle class="page" @click="$router.push('/first')">Second</v-flex>
</template>

<script lang="ts">
import { Vue } from 'vue-property-decorator';

export default class Second extends Vue {}
</script>
