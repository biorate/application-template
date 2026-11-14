---
unless_exists: true
mirror: true
---
import { Injectable } from '@nestjs/common';
import { DebugDrivenPort } from '@/app/application/port';
import { Info } from '@/app/domain';
import { GETInfo } from './request';

@Injectable()
export class DebugHttpAdapter implements DebugDrivenPort {
  public async getClientConfig() {
    const { data } = await GETInfo.fetch({});
    return new Info(data);
  }
}
