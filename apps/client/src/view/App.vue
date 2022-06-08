<style>
.test {
  font-size: 30px;
}
</style>

<template>
  <div class="test" v-for="item of $store.state.arr">test {{ b }}</div>
</template>

<script lang="ts">
import { Vue, Prop, Provide } from 'vue-property-decorator';
import { init, injectable, Types } from '@biorate/inversion';

export default class App extends Vue {
  @Prop({ default: 10 }) protected readonly prop: number;

  @Provide() protected foo = 'foo';

  public created() {}

  public mounted() {}
}

// import { defineComponent } from 'vue';
//
// export default defineComponent({
//   name: 'App',
//
//   props: {
//     title: String,
//     likes: Number,
//   },
//
//   data() {
//     return {
//       message: 'Hello world!!!',
//       array: [1, 2, 3],
//     };
//   },
//
//   setup() {
//     console.log('setup');
//   },
//
//   updated() {
//     console.log('updated');
//   },
//
//   mounted() {
//     // const store = useStore<{ a: number; b: number; arr: number[] }>(Symbol.for('key1'));
//     // console.log(store.state);
//     setInterval(() => {
//       // this.$store.state.arr[1]++;
//       // this.$store.state.a++;
//       this.$store.state.action();
//     }, 1000);
//   },
// });
</script>
