<style scoped>
.flex {
  display: flex;
}
</style>

<template>
  <div class="flex" :style="style">
    <slot />
  </div>
</template>

<script lang="ts">
import { Vue, Prop } from 'vue-property-decorator';

export default class Flex extends Vue {
  @Prop({ default: false, type: [Boolean, Number] }) protected readonly cols:
    | boolean
    | number;
  @Prop({ default: false, type: Boolean }) protected readonly column: boolean;

  @Prop({ default: false, type: Boolean }) protected readonly start: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly center: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly end: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly around: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly between: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly evenly: boolean;

  @Prop({ default: false, type: Boolean }) protected readonly top: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly middle: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly bottom: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly baseline: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly stretch: boolean;

  @Prop({ default: false, type: Boolean }) protected readonly selfTop: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly selfMiddle: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly selfBottom: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly selfBaseline: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly selfStetch: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly selfAuto: boolean;

  @Prop({ default: false, type: Boolean }) protected readonly contentStart: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly contentCenter: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly contentEnd: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly contentAround: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly contentBetween: boolean;
  @Prop({ default: false, type: Boolean }) protected readonly contentStretch: boolean;

  protected get _column() {
    return this.column ? 'column' : 'row';
  }

  protected get _cols() {
    if (this.cols === true) return 1;
    else if (this.cols > 0) return this.cols;
    else return undefined;
  }

  protected get _justify() {
    if (this.start) return 'flex-start';
    else if (this.center) return 'center';
    else if (this.end) return 'flex-end';
    else if (this.around) return 'space-around';
    else if (this.between) return 'space-between';
    else if (this.evenly) return 'space-evenly';
    else return undefined;
  }

  protected get _alignItems() {
    if (this.top) return 'flex-start';
    else if (this.middle) return 'center';
    else if (this.bottom) return 'flex-end';
    else if (this.baseline) return 'baseline';
    else if (this.stretch) return 'stretch';
    else return undefined;
  }

  protected get _alignSelf() {
    if (this.selfTop) return 'flex-start';
    else if (this.selfMiddle) return 'center';
    else if (this.selfBottom) return 'flex-end';
    else if (this.selfBaseline) return 'baseline';
    else if (this.selfStetch) return 'stretch';
    else if (this.selfAuto) return 'auto';
    else return undefined;
  }

  get _alignContent() {
    if (this.contentStart) return 'flex-start';
    else if (this.contentCenter) return 'center';
    else if (this.contentEnd) return 'flex-end';
    else if (this.contentAround) return 'space-around';
    else if (this.contentBetween) return 'space-between';
    else if (this.contentStretch) return 'stretch';
    else return undefined;
  }

  protected get style() {
    return {
      flexGrow: this._cols,
      flexDirection: this._column,
      justifyContent: this._justify,
      alignItems: this._alignItems,
      alignSelf: this._alignSelf,
      alignContent: this._alignContent,
    };
  }
}
</script>
