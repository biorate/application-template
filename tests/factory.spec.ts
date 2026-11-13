import { suite, test } from '@biorate/vitest';
import { Spec } from '@biorate/vitest-spec';
import path from 'path';
import fs from 'fs';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const factory = require('../.hygen.js');

const ROOT = path.resolve(__dirname, '..');
const TEMPLATES = path.join(ROOT, '_templates');

const run = (locals: Record<string, unknown>) =>
  factory.helpers(
    { _: ['create', 'root'], action: 'root', ...locals },
    { templates: TEMPLATES },
  );

@suite('Factory (.hygen.js helpers)')
class FactorySpec extends Spec {
  protected get httpServer() {
    return null;
  }

  @test('derives CLIENT/SERVER from the action list')
  derivation() {
    const all = run({
      root: '/tmp/x',
      'app-name': 'a',
      'app-description': 'd',
      _: ['create', 'root,client,server'],
    });
    this.exactly([all.CLIENT, all.SERVER], [true, true]);

    const clientOnly = run({
      root: '/tmp/x',
      'app-name': 'a',
      'app-description': 'd',
      _: ['create', 'root,client'],
    });
    this.exactly([clientOnly.CLIENT, clientOnly.SERVER], [true, false]);

    const serverOnly = run({
      root: '/tmp/x',
      'app-name': 'a',
      'app-description': 'd',
      _: ['create', 'root,server'],
    });
    this.exactly([serverOnly.CLIENT, serverOnly.SERVER], [false, true]);
  }

  @test('unknown actions in the list are ignored')
  'unknown-actions'() {
    const h = run({
      root: '/tmp/x',
      'app-name': 'a',
      'app-description': 'd',
      _: ['create', 'root,unknown,client'],
    });
    this.exactly([h.CLIENT, h.SERVER], [true, false]);
  }

  @test('derives names from --app-name')
  names() {
    const h = run({ root: '/tmp/x', 'app-name': 'my-app', 'app-description': 'd' });
    this.exactly(
      {
        ROOT: h.ROOT,
        APP_NAME: h.APP_NAME,
        CLIENT_NAME: h.CLIENT_NAME,
        SERVER_NAME: h.SERVER_NAME,
      },
      {
        ROOT: '/tmp/x',
        APP_NAME: 'my-app',
        CLIENT_NAME: 'my-app-client',
        SERVER_NAME: 'my-app-server',
      },
    );
  }

  @test('passes flags through (CUT_EXAMPLES / ADD_WEB_SOCKET)')
  flags() {
    const h = run({
      root: '/tmp/x',
      'app-name': 'a',
      'app-description': 'd',
      'cut-examples': true,
      'add-web-socket': true,
    });
    this.exactly([h.CUT_EXAMPLES, h.ADD_WEB_SOCKET], [true, true]);
  }

  @test('throws on missing --root')
  'missing-root'() {
    let error: Error = null;
    try {
      run({ 'app-name': 'a', 'app-description': 'd' });
    } catch (e) {
      error = e;
    }
    this.exactly(error?.message, '[--root] is not defined');
  }

  @test('throws on missing --app-name and --app-description')
  'missing-name'() {
    let error: Error = null;
    try {
      run({ root: '/tmp/x' });
    } catch (e) {
      error = e;
    }
    this.exactly(error?.message, '[--app-name], [--app-description] is not defined');
  }

  @test('guard: exact repository root match throws')
  'guard-exact'() {
    let error: Error = null;
    try {
      run({ root: ROOT, 'app-name': 'a', 'app-description': 'd' });
    } catch (e) {
      error = e;
    }
    this.exactly(error?.message.includes('is the template repository itself'), true);
  }

  @test('guard: nested paths inside the repository are allowed')
  'guard-nested'() {
    const h = run({
      root: path.join(ROOT, 'tmp', 'some-app'),
      'app-name': 'a',
      'app-description': 'd',
    });
    this.exactly(h.ROOT, path.join(ROOT, 'tmp', 'some-app'));
  }

  @test('guard: non-existent root is allowed (created later)')
  'guard-missing-dir'() {
    const h = run({
      root: '/tmp/definitely-not-exists-guard',
      'app-name': 'a',
      'app-description': 'd',
    });
    this.exactly(h.ROOT, '/tmp/definitely-not-exists-guard');
  }

  @test('help action skips validation')
  help() {
    const h = factory.helpers(
      { _: ['create', 'help'], action: 'help' },
      { templates: TEMPLATES },
    );
    this.exactly('_' in h, true);
  }

  @test('root and repo .hygen.js.t stay in sync')
  'sync-with-template'() {
    const rootFactory = fs.readFileSync(path.join(ROOT, '.hygen.js'), 'utf8');
    const templateFactory = fs.readFileSync(
      path.join(TEMPLATES, 'create', 'root', '.hygen.js.t'),
      'utf8',
    );
    this.exactly(templateFactory, rootFactory);
  }
}
