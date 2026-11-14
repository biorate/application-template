---
unless_exists: true
mirror: true
---
/* istanbul ignore file */
import 'source-map-support/register';
import { container } from '@biorate/inversion';
import { Root } from '@/app/infrastructure/bootstrap';

container.get(Root).$run();
