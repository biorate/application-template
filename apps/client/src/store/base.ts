import { injectable } from '@biorate/inversion';
import { has, set } from 'lodash';
import { IStore } from '../interfaces';
import { mutation } from './decorators';

@injectable()
export class Base implements IStore.IBase {
  @mutation public set(data: Record<string, unknown>) {
    for (const path in data) if (has(this, path)) set(this, path, data[path]);
  }
}
