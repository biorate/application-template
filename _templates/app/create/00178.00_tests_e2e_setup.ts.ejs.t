---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/e2e/setup.ts`) %>
unless_exists: true
---
import { container } from '@biorate/inversion';
import { assignPmsUrl, assignTmsUrl } from '@biorate/vitest';
import { Root } from '@/app/infrastructure/bootstrap';
import '../common/common-spec';
import '../__mocks__/e2e';

beforeAll(async function () {
  assignTmsUrl(process.env.TMS_URL);
  assignPmsUrl(process.env.PMS_URL);
  await container.get<Root>(Root).$run();
});
