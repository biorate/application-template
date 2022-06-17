import { create } from '@biorate/symbolic';
import { IStore } from '../interfaces';

export const Vuex = create('Vuex');

export const Mutation =
  () => (target: Object, propertyKey: string, descriptor: PropertyDescriptor) => {
    let metadata = Reflect.getMetadata(Vuex.Mutations, target);
    if (!metadata) metadata = {};
    metadata[propertyKey] = descriptor.value;
    Reflect.defineMetadata(Vuex.Mutations, metadata, target);
  };

export const Actions =
  () => (target: Object, propertyKey: string, descriptor: PropertyDescriptor) => {
    let metadata = Reflect.getMetadata(Vuex.Actions, target);
    if (!metadata) metadata = {};
    metadata[propertyKey] = descriptor.value;
    Reflect.defineMetadata(Vuex.Actions, metadata, target);
  };

export const getMutations = (store: IStore.IStoreBase<unknown>) => {
  const metadata = Reflect.getMetadata(Vuex.Mutations, store);
  if (!metadata) return;
  const mutations = {};
  for (const field in metadata)
    mutations[field] = (store, args) => metadata[field].apply(store, args);
  return mutations;
};

export const getActions = (store: IStore.IStoreBase<unknown>) => {
  const metadata = Reflect.getMetadata(Vuex.Actions, store);
  if (!metadata) return;
  const actions = {};
  for (const field in metadata)
    actions[field] = (store, args) => metadata[field].apply(store, args);
  return actions;
};
