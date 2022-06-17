<style scoped>
.page {
  user-select: none;
  background: azure;
  width: 100%;
  height: 100px;
}
</style>

<template>
  <Flex center middle class="page" @click="$router.push('/page1')">Page2</Flex>
</template>

<script lang="ts">
import { Vue } from 'vue-property-decorator';

export default class App extends Vue {}
</script>
