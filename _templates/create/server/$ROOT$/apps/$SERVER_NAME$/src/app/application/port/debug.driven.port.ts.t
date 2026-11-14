---
unless_exists: true
mirror: true
---
import { Info } from '@/app/domain';

export interface DebugDrivenPort {
  getClientConfig(): Promise<Info>;
}
