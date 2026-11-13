---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/e2e/probes.e2e.spec.ts`) %>
unless_exists: true
---
import { suite, test, description, epic, feature, owner, tag } from '@biorate/vitest';
import { CommonSpec } from '../common/common-spec';

@suite('Probes (E2E)')
@epic('E2E tests')
@feature('Probes')
@owner('backend-team')
@tag('e2e')
class ProbesE2ESpec extends CommonSpec {
  @feature('Readiness')
  @description('E2E: GET /probe/readiness')
  @test('GET /probe/readiness returns 200')
  protected async probeReadiness() {
    await this.supertest.get('/probe/readiness').expect(200);
  }

  @feature('Healthz')
  @description('E2E: GET /probe/healthz')
  @test('GET /probe/healthz returns 200')
  protected async probeHealthz() {
    await this.supertest.get('/probe/healthz').expect(200);
  }
}
