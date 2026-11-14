---
unless_exists: true
mirror: true
---
import { Info } from '@/app/domain';

export interface InfoDrivenPort {
  getInfo(): Promise<Info>;
}
