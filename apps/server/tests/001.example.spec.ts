import { container } from '@biorate/inversion';
import { Root } from './__mocks__';

describe('Example', function () {
  this.timeout(3e4);

  before(async () => {
    await container.get(Root).$run();
  });

  it('/api/probe/readiness (GET)', (done) => {
    Root.supertest.get('/api/probe/readiness').expect(200, done);
  });

  it('/api/probe/healthz (GET)', (done) => {
    Root.supertest.get('/api/probe/healthz').expect(200, done);
  });
});
