---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/setup.ts`) %>
unless_exists: true
---
import { container } from '@biorate/inversion';
import {
  assignPmsUrl,
  assignTmsUrl,
  decorate,
  allure,
} from '@biorate/vitest';
import { Root } from '../src/app/infrastructure/bootstrap/root-config';
import './__mocks__';

beforeAll(async function () {
  decorate(allure);
  assignTmsUrl(process.env.TMS_URL);
  assignPmsUrl(process.env.PMS_URL);
  await container.get(Root).$run();
});

afterAll(async function () {});
