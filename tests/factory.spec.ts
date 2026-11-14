import { suite, test } from '@biorate/vitest';
import path from 'path';
import fs from 'fs';
import os from 'os';
import { UnitSpec } from './common/unit-spec';
import { ROOT, TEMPLATES, runFactory } from './common/generator-spec';

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

  @test('throws on missing --root')
  'missing-root'() {
    let error: Error | undefined;
    try {
      runFactory({ 'app-name': 'a', 'app-description': 'd' });
    } catch (e) {
      error = e as Error;
    }
    this.exactly(error?.message, '[--root] is not defined');
  }

  @test('throws on missing --app-name and --app-description')
  'missing-name'() {
    let error: Error | undefined;
    try {
      runFactory({ root: os.tmpdir() });
    } catch (e) {
      error = e as Error;
    }
    this.exactly(error?.message, '[--app-name], [--app-description] is not defined');
  }

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

  @test('root and repo .hygen.ts.t stay in sync')
  'sync-with-template'() {
    const rootFactory = fs.readFileSync(path.join(ROOT, '.hygen.ts'), 'utf8');
    const templateFactory = fs.readFileSync(
      path.join(TEMPLATES, 'create', 'root', '$ROOT$', '.hygen.ts.t'),
      'utf8',
    );
    // шаблон несёт frontmatter (mirror/unless_exists) — сравниваем только тело
    const body = templateFactory.replace(/^---\n[\s\S]*?\n---\n/, '');
    this.exactly(body, rootFactory);
  }
}
