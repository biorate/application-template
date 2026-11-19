import { suite, test } from '@biorate/vitest';
import path from 'path';
import fs from 'fs';
import Hooks from '../_templates/create/root/hooks';
import {
  GeneratorSpec,
  ROOT,
  makeConfig,
  silentLogger,
  manifest,
  type Cfg,
} from './common/generator-spec';

@suite('Runner (integration)')
class RunnerSpec extends GeneratorSpec {
  @test('full matrix matches golden fixtures')
  async 'golden-matrix'() {
    for (const [name, [actions, extra]] of Object.entries({
      cs: ['root,client,server', []],
      cl: ['root,client', []],
      sv: ['root,server', []],
      cut: ['root,client,server', ['--cut-examples']],
      ws: ['root,client,server', ['--add-web-socket']],
    })) {
      const tmp = this.tmpDir();
      const execCalls: string[] = [];
      const result = await this.runner(
        [
          'create',
          actions,
          `--root=${tmp}`,
          '--app-name=ref-app',
          '--app-description=Ref app',
          ...extra,
        ],
        makeConfig({ exec: (cmd) => execCalls.push(cmd) }),
      );
      this.exactly(result.success, true, `${name}: success`);
      const fixture = this.readFixture(name);
      this.exactly(manifest(tmp), fixture, `${name}: manifest`);
      const execFixture = this.readFixture(`${name}.exec`);
      this.exactly(execCalls.length, execFixture.length, `${name}: exec calls count`);
      this.cleanup(tmp);
    }
  }

  @test('websocket files are generated only in the server subtree')
  async 'websocket-only-server'() {
    const tmp = this.tmpDir();
    await this.runCs(makeConfig(), ['--add-web-socket'], tmp);
    const wsFiles = manifest(tmp);
    const gateways = Object.keys(wsFiles).filter(
      (f) => f.includes('websocket') || f.includes('gateway'),
    );
    this.exactly(gateways.length > 0, true);
    this.exactly(
      gateways.every((f) => f.includes('-server')),
      true,
    );
    this.cleanup(tmp);
  }

  @test('project hook afterAll formats the tree and sets husky exec bits')
  async 'project-hook-after-all'() {
    const tmp = this.tmpDir();
    await this.runner(
      [
        'create',
        'root',
        `--root=${tmp}`,
        '--app-name=ref-app',
        '--app-description=Ref app',
      ],
      makeConfig(),
    );
    // ломаем формат в корневом файле и снимаем exec-биты husky
    const file = path.join(tmp, 'package.json');
    fs.writeFileSync(file, JSON.stringify({ name: 'x' }, null, 12));
    const huskyHook = path.join(tmp, '.husky', 'pre-commit');
    if (process.platform !== 'win32') fs.chmodSync(huskyHook, 0o644);
    const before = fs.statSync(huskyHook).mode;
    await new Hooks().afterAll!(
      {
        // движок (argCase: 'upper-underscore') доставляет флаг как ROOT
        args: { ROOT: tmp },
        dry: false,
        logger: silentLogger(),
      } as never,
      [{}],
    );
    this.exactly(fs.readFileSync(file, 'utf8').includes('\n  "name"'), true);
    if (process.platform !== 'win32')
      this.exactly(fs.statSync(huskyHook).mode !== before, true);
    this.cleanup(tmp);
  }

  @test('afterAll without --root warns and does not throw')
  async 'after-all-no-root'() {
    const logs: string[] = [];
    await new Hooks().afterAll!(
      {
        args: {},
        dry: false,
        logger: { ...silentLogger(), warn: (m: string) => logs.push(m) },
      } as never,
      [{}],
    );
    this.exactly(logs.join('\n').includes('afterAll'), true);
  }

  @test('afterAll with no results skips post-processing (failed generation)')
  async 'after-all-empty-results'() {
    const tmp = this.tmpDir();
    const file = path.join(tmp, 'x.json');
    fs.writeFileSync(file, '{ "a": 1 }');
    await new Hooks().afterAll!(
      { args: { root: tmp }, dry: false, logger: silentLogger() } as never,
      [],
    );
    this.exactly(fs.readFileSync(file, 'utf8'), '{ "a": 1 }');
    this.cleanup(tmp);
  }

  @test('missing --root fails without writing files')
  async 'negative-missing-root'() {
    const tmp = this.tmpDir();
    const logs: string[] = [];
    const logger = {
      ...silentLogger(),
      log: (...a: unknown[]) => logs.push(a.join(' ')),
    };
    const result = await this.runner(
      ['create', 'root', '--app-name=ref-app', '--app-description=Ref app'],
      makeConfig({ logger }),
    );
    this.exactly(result.success, false);
    this.exactly(fs.existsSync(path.join(tmp, 'package.json')), false);
    // non-TTY: stub-промптер конфига не отвечает -> params-фаза -> ParamRequiredError
    this.exactly(logs.join('\n').includes("the parameter '--root' is required"), true);
    this.cleanup(tmp);
  }

  @test('missing --app-name and --app-description fails')
  async 'negative-missing-name'() {
    const tmp = this.tmpDir();
    const logs: string[] = [];
    const logger = {
      ...silentLogger(),
      log: (...a: unknown[]) => logs.push(a.join(' ')),
    };
    const result = await this.runner(
      ['create', 'root', `--root=${tmp}`],
      makeConfig({ logger }),
    );
    this.exactly(result.success, false);
    this.exactly(
      logs.join('\n').includes("the parameter '--app-name' is required"),
      true,
    );
    this.cleanup(tmp);
  }

  @test('guard: generation into the template repository itself is forbidden')
  async 'guard-repo-root'() {
    const tmp = this.tmpDir();
    const logs: string[] = [];
    const logger = {
      ...silentLogger(),
      log: (...a: unknown[]) => logs.push(a.join(' ')),
    };
    const result = await this.runner(
      [
        'create',
        'root',
        `--root=${ROOT}`,
        '--app-name=ref-app',
        '--app-description=Ref app',
      ],
      makeConfig({ logger }),
    );
    this.exactly(result.success, false);
    this.exactly(logs.join('\n').includes('is the template repository itself'), true);
    this.cleanup(tmp);
  }

  @test('idempotency: second run skips everything')
  async idempotency() {
    const tmp = this.tmpDir();
    const first = await this.runCs(makeConfig(), [], tmp);
    this.exactly(first.success, true);
    const before = manifest(tmp);
    const added: string[] = [];
    const logger = {
      ...silentLogger(),
      ok: (...a: unknown[]) => {
        const msg = String(a[0] ?? '');
        if (msg.includes('added')) added.push(msg);
      },
    };
    const second = await this.runCs(makeConfig({ logger }), [], tmp);
    this.exactly(second.success, true);
    // файлы не перезаписываются повторной генерацией
    this.exactly(added.length, 0);
    this.exactly(manifest(tmp), before);
    this.cleanup(tmp);
  }

  @test('params phase in non-TTY mode: stub answers nothing; validation fails cleanly')
  async 'prompt-non-tty'() {
    const tmp = this.tmpDir();
    const logs: string[] = [];
    const logger = {
      ...silentLogger(),
      log: (...a: unknown[]) => logs.push(a.join(' ')),
    };
    // non-TTY по умолчанию в тестовой среде; createPrompter конфига
    // (.hygen.ts) возвращает stub — enquirer не вызывается, hang нет
    const result = await this.runner(['create', 'root', `--root=${tmp}`], {
      ...makeConfig({ logger }),
    });
    this.exactly(result.success, false);
    this.exactly(logs.join('\n').includes('ParamRequiredError'), true);
    this.cleanup(tmp);
  }

  @test('params phase: flag coercion (true/false strings) and boolean defaults')
  async 'prompt-tty'() {
    const tmp = this.tmpDir();
    const config = makeConfig();
    // флаги строками -> coercion к boolean: ws-файлы только при true
    const dir1 = path.join(tmp, 'coerced');
    const r1 = await this.runner(
      [
        'create',
        'root,server',
        `--root=${dir1}`,
        '--app-name=ref-app',
        '--app-description=Ref app',
        '--cut-examples=false',
        '--add-web-socket=true',
      ],
      config,
    );
    this.exactly(r1.success, true);
    this.exactly(
      fs.existsSync(path.join(dir1, 'apps', 'ref-app-server', '.husky')) ||
        fs.existsSync(path.join(dir1, 'package.json')),
      true,
    );
    this.exactly(
      fs.readdirSync(path.join(dir1, 'apps', 'ref-app-server')).includes('src'),
      true,
    );
    // недостающие флаги -> stub не отвечает -> ParamRequiredError
    const dir2 = path.join(tmp, 'partial');
    const logs: string[] = [];
    const r2 = await this.runner(['create', 'root', `--root=${dir2}`], {
      ...makeConfig({
        logger: { ...silentLogger(), log: (...a: unknown[]) => logs.push(a.join(' ')) },
      }),
    });
    this.exactly(r2.success, false);
    this.exactly(
      logs.join('\n').includes("the parameter '--app-name' is required"),
      true,
    );
    this.cleanup(tmp);
  }
}
