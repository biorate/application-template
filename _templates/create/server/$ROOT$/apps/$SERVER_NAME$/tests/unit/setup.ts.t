---
unless_exists: true
mirror: true
---
import { assignPmsUrl, assignTmsUrl } from '@biorate/vitest';

beforeAll(() => {
  assignTmsUrl(process.env.TMS_URL);
  assignPmsUrl(process.env.PMS_URL);
});
