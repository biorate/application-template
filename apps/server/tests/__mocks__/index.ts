import { use } from 'chai';
import * as supertest from 'supertest';
import { SuperTest, Test } from 'supertest';
import { jestSnapshotPlugin } from 'mocha-chai-jest-snapshot';
import { container, init } from '@biorate/inversion';
import { Root as BaseRoot } from '../../src/config';

use(jestSnapshotPlugin());

export class Root extends BaseRoot {
  public static supertest: SuperTest<Test> = null;

  @init() private async initialize() {
    Root.supertest = supertest(this.application.app.getHttpServer());
  }
}

container.bind<Root>(Root).toSelf().inSingletonScope();
