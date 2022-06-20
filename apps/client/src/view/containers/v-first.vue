<style scoped>
.page {
  user-select: none;
  background: aqua;
  width: 100%;
  height: 100px;
}
</style>

<template>
  <v-flex center middle class="page" @click="$router.push('/second')">First</v-flex>
</template>

<script lang="ts">
import { Vue } from 'vue-property-decorator';

export default class First extends Vue {}
</script>
