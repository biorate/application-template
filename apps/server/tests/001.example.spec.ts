import { container } from '@biorate/inversion';
import { suite, test, timeout } from '@biorate/mocha';
import { Done } from 'mocha';
import { Root } from './__mocks__';

@suite('Example')
@timeout(4000)
class Example {
  protected static async before() {
    await container.get(Root).$run();
  }

  @test('/probe/readiness (GET)')
  protected probeReadiness(done: Done) {
    Root.supertest.get('/probe/readiness').expect(200, done);
  }

  @test('/probe/healthz (GET)')
  protected probeHealthz(done: Done) {
    Root.supertest.get('/probe/healthz').expect(200, done);
  }
}
