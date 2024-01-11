import { container } from '@biorate/inversion';
import { use } from 'chai';
import {
  assignPmsUrl,
  assignTmsUrl,
  decorate,
  allure,
  MochaAllure,
} from '@biorate/mocha';
import { jestSnapshotPlugin } from 'mocha-chai-jest-snapshot';
import { Root } from '../src/config';
import './__mocks__';

use(jestSnapshotPlugin());

before(async () => {
  decorate<MochaAllure>(allure);
  assignTmsUrl(process.env.TMS_URL);
  assignPmsUrl(process.env.PMS_URL);
  await container.get(Root).$run();
});
