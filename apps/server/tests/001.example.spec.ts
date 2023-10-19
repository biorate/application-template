import { container } from '@biorate/inversion';
import { Root } from './__mocks__';

describe('Example', function () {
  this.timeout(3e4);

  before(async () => {
    await container.get(Root).$run();
  });

  it('/probe/readiness (GET)', (done) => {
    Root.supertest.get('/probe/readiness').expect(200, done);
  });

  it('/probe/healthz (GET)', (done) => {
    Root.supertest.get('/probe/healthz').expect(200, done);
  });
});
