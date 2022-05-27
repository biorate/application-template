<style>
.test {
  font-size: 30px;
}
</style>

<template>
  <div class="test" v-for="item of array">
    {{ item }} {{ message }} {{ $store.state.a }} {{ $store.state.b }}
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'App',

  data() {
    return {
      message: 'Hello world!!!',
      array: [1, 2, 3],
    };
  },

  mounted() {
    setInterval(() => {
      this.$store.state.a++;
      this.$store.state.action();
    }, 1000);
  },
});
</script>
