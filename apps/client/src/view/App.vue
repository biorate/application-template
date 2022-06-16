<style scoped>
.test {
  font-size: 30px;
}
</style>

<template>
  <div class="test">test</div>
  <div>{{ hello.state.world }}</div>
  <test prop-a="123" />
</template>

<script lang="ts">
import { useStore } from 'vuex';
import { Vue, Prop, Provide, Ref } from 'vue-property-decorator';
import { inject, Types } from '@biorate/inversion';
import { Hello } from '../store';
// import { init, injectable, Types } from '@biorate/inversion';

export default class App extends Vue {
  protected hello = useStore<Hello>(Types.Hello);

  @Prop({ default: 10 }) protected readonly prop: number;

  @Provide() protected foo = 1;

  public created() {
    console.log(this.hello.state.world);
  }

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
