---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/src/index.ts`) %>
unless_exists: true
---
/* istanbul ignore file */
import 'source-map-support/register';
import { container } from '@biorate/inversion';
import { Root } from '@/app/infrastructure/bootstrap';

container.get(Root).$run();
