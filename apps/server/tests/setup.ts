import { container } from '@biorate/inversion';
import { assignPmsUrl, assignTmsUrl, decorate } from 'allure-decorators';
import { allure, MochaAllure } from 'allure-mocha/runtime';
import { jestSnapshotPlugin } from 'mocha-chai-jest-snapshot';
import { use } from 'chai';
import { Root } from '../src/config';
import './__mocks__';

use(jestSnapshotPlugin());

before(async () => {
  decorate<MochaAllure>(allure);
  assignTmsUrl(process.env.TMS_URL);
  assignPmsUrl(process.env.PMS_URL);
  await container.get(Root).$run();
});
