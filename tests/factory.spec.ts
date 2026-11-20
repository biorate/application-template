import { suite, test } from '@biorate/vitest';
import path from 'path';
import os from 'os';
import { UnitSpec } from './common/unit-spec';
import { ROOT, loadFactory, normalizeConfig, runFactory } from './common/generator-spec';
import Hooks from '../_templates/create/root/hooks';
import ClientHooks from '../_templates/create/client/hooks';
import ServerHooks from '../_templates/create/server/hooks';

@suite('Factory (.hygen.ts helpers)')
class FactorySpec extends UnitSpec {
  @test('derives CLIENT/SERVER from the action list')
  derivation() {
    const all = runFactory({
      root: os.tmpdir(),
      'app-name': 'a',
      'app-description': 'd',
      _: ['create', 'root,client,server'],
    });
    this.exactly([all.CLIENT, all.SERVER], [true, true]);

    const clientOnly = runFactory({
      root: os.tmpdir(),
      'app-name': 'a',
      'app-description': 'd',
      _: ['create', 'root,client'],
    });
    this.exactly([clientOnly.CLIENT, clientOnly.SERVER], [true, false]);

    const serverOnly = runFactory({
      root: os.tmpdir(),
      'app-name': 'a',
      'app-description': 'd',
      _: ['create', 'root,server'],
    });
    this.exactly([serverOnly.CLIENT, serverOnly.SERVER], [false, true]);
  }

  @test('unknown actions in the list are ignored')
  'unknown-actions'() {
    const h = runFactory({
      root: os.tmpdir(),
      'app-name': 'a',
      'app-description': 'd',
      _: ['create', 'root,unknown,client'],
    });
    this.exactly([h.CLIENT, h.SERVER], [true, false]);
  }

  @test('derives names from --app-name')
  names() {
    const h = runFactory({
      root: os.tmpdir(),
      'app-name': 'my-app',
      'app-description': 'd',
    });
    this.exactly(
      {
        ROOT: h.ROOT,
        APP_NAME: h.APP_NAME,
        CLIENT_NAME: h.CLIENT_NAME,
        SERVER_NAME: h.SERVER_NAME,
      },
      {
        ROOT: os.tmpdir(),
        APP_NAME: 'my-app',
        CLIENT_NAME: 'my-app-client',
        SERVER_NAME: 'my-app-server',
      },
    );
  }

  @test('passes flags through (CUT_EXAMPLES / ADD_WEB_SOCKET)')
  flags() {
    const h = runFactory({
      root: os.tmpdir(),
      'app-name': 'a',
      'app-description': 'd',
      'cut-examples': true,
      'add-web-socket': true,
    });
    this.exactly([h.CUT_EXAMPLES, h.ADD_WEB_SOCKET], [true, true]);
  }

  // Валидация обязательных флагов (root, app-name, app-description) выполняется
  // params-фазой движка @biorate/hygen, в фабрике хелперов не дублируется.

  @test('guard: exact repository root match throws')
  'guard-exact'() {
    let error: Error | undefined;
    try {
      runFactory({ root: ROOT, 'app-name': 'a', 'app-description': 'd' });
    } catch (e) {
      error = e as Error;
    }
    this.exactly(error?.message.includes('is the template repository itself'), true);
  }

  @test('guard: nested paths inside the repository are allowed')
  'guard-nested'() {
    const h = runFactory({
      root: path.join(ROOT, 'tmp', 'some-app'),
      'app-name': 'a',
      'app-description': 'd',
    });
    this.exactly(h.ROOT, path.join(ROOT, 'tmp', 'some-app'));
  }

  @test('guard: non-existent root is allowed (created later)')
  'guard-missing-dir'() {
    const h = runFactory({
      root: '/tmp/definitely-not-exists-guard',
      'app-name': 'a',
      'app-description': 'd',
    });
    this.exactly(h.ROOT, '/tmp/definitely-not-exists-guard');
  }

  @test('help action skips validation')
  help() {
    const h = runFactory({ _: ['create', 'help'], action: 'help' });
    this.exactly('_' in h, true);
  }

  @test('root action hooks declare lifecycle afterAll')
  'lifecycle-hooks'() {
    this.exactly(typeof new Hooks().afterAll, 'function');
  }

  @test('action hooks declare params as an instance property')
  'hooks-instance-params'() {
    for (const Ctor of [Hooks, ClientHooks, ServerHooks]) {
      const anyCtor = Ctor as unknown as { params?: unknown };
      this.exactly(anyCtor.params, undefined, 'no static params');
      const params = new Ctor().params as Array<{
        name: string;
        type: string;
        required?: boolean;
        default?: unknown;
      }>;
      this.exactly(
        params.map((p) => [p.name, p.type, p.required, p.default ?? null]),
        [
          ['root', 'string', true, null],
          ['app-name', 'string', true, null],
          ['app-description', 'string', true, null],
          ['cut-examples', 'boolean', true, false],
          ['add-web-socket', 'boolean', true, false],
        ],
        Ctor.name,
      );
    }
  }

  @test('factory config declares no params (per-action hooks own the schema)')
  'factory-no-params'() {
    const project = normalizeConfig(loadFactory() as Record<string, unknown>);
    this.exactly('params' in project, false);
  }
}
