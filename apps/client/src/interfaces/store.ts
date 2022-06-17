export namespace IStore {
  export interface IBase {
    set(data: Record<string, unknown>): void;
  }

  export interface IHello extends IBase {
    world: number;
  }
}
