import { create } from '@biorate/symbolic';

const decorate =
  (symbol: symbol) =>
  (target: Object, propertyKey: string, descriptor: PropertyDescriptor) => {
    let metadata = Reflect.getMetadata(symbol, target);
    if (!metadata) metadata = {};
    metadata[propertyKey] = descriptor.value;
    Reflect.defineMetadata(symbol, metadata, target);
  };

const getDecorated = (symbol: symbol) => (store: unknown) => {
  const metadata = Reflect.getMetadata(symbol, store);
  if (!metadata) return;
  const data = {};
  for (const field in metadata)
    data[field] = (store: { state: unknown }, ...args) =>
      metadata[field].apply(store.state ?? store, args);
  return data;
};

export const Vuex = create('Vuex');

export const mutation = decorate(Vuex.Mutations);

export const action = decorate(Vuex.Actions);

export const getMutations = getDecorated(Vuex.Mutations);

export const getActions = getDecorated(Vuex.Actions);
