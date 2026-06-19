---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/unit/setup.ts`) %>
unless_exists: true
---
import { assignPmsUrl, assignTmsUrl } from '@biorate/vitest';

beforeAll(() => {
  assignTmsUrl(process.env.TMS_URL);
  assignPmsUrl(process.env.PMS_URL);
});
