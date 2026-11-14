import { suite, test } from '@biorate/vitest';
import path from 'path';
import fs from 'fs';
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

  @test('z-after (prettier, chmod husky on linux) is executed last')
  async 'order-z-after-last'() {
    const tmp = this.tmpDir();
    const execCalls: string[] = [];
    await this.runner(
      [
        'create',
        'root',
        `--root=${tmp}`,
        '--app-name=ref-app',
        '--app-description=Ref app',
      ],
      makeConfig({ exec: (cmd) => execCalls.push(cmd) }),
    );
    this.exactly(execCalls.length > 0, true);
    const last = execCalls[execCalls.length - 1];
    this.exactly(last.includes('prettier'), true);
    if (process.platform === 'linux') this.exactly(last.includes('chmod ug+x'), true);
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
    this.exactly(logs.join('\n').includes('[--root] is not defined'), true);
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
      logs.join('\n').includes('[--app-name], [--app-description] is not defined'),
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
    // шелл-опы (a-before/z-after) исполняются всегда, файлы — не перезаписываются
    this.exactly(added.length, 0);
    this.exactly(manifest(tmp), before);
    this.cleanup(tmp);
  }

  @test('hooks.ts (class) in non-TTY mode asks nothing; factory validates')
  async 'prompt-non-tty'() {
    const tmp = this.tmpDir();
    const questions: unknown[] = [];
    const config = makeConfig({
      createPrompter: () => ({
        prompt: async (qs: { name: string }[]) => (questions.push(...qs), {}),
      }),
    });
    // non-TTY по умолчанию в тестовой среде
    const result = await this.runner(['create', 'root', `--root=${tmp}`], config);
    this.exactly(result.success, false);
    this.exactly(questions.length, 0);
    this.cleanup(tmp);
  }

  @test(
    'hooks.ts (class) in TTY mode asks only about missing params; answers reach the factory',
  )
  async 'prompt-tty'() {
    const tmp = this.tmpDir();
    const wasTty = (process.stdin as unknown as { isTTY?: boolean }).isTTY;
    Object.defineProperty(process.stdin, 'isTTY', { value: true, configurable: true });
    try {
      const questions: { name: string; type: string }[] = [];
      const answers: Record<string, unknown> = {};
      const config = makeConfig({
        createPrompter: () => ({
          prompt: async (qs: { name: string; type: string }[]) => {
            questions.push(...qs);
            // программные ответы: имя приложения и описание
            for (const q of qs) if (q.type === 'input') answers[q.name] = 'answered-app';
            return answers;
          },
        }),
      });
      // все флаги переданы -> confirm-вопросы только о флагах (по дизайну D9)
      const dir1 = path.join(tmp, 'full');
      const r1 = await this.runner(
        [
          'create',
          'root',
          `--root=${dir1}`,
          '--app-name=ref-app',
          '--app-description=Ref app',
        ],
        config,
      );
      this.exactly(r1.success, true);
      this.exactly(questions.map((q) => q.name).sort(), [
        'add-web-socket',
        'cut-examples',
      ]);

      // без флагов -> вопросы о missing (root не спрашивается);
      // hooks.ts вызывается на каждое действие (root, client) — сравниваем уникальные имена
      questions.length = 0;
      const dir2 = path.join(tmp, 'partial');
      const r2 = await this.runner(['create', 'root,client', `--root=${dir2}`], config);
      this.exactly(r2.success, true);
      this.exactly([...new Set(questions.map((q) => q.name))].sort(), [
        'add-web-socket',
        'app-description',
        'app-name',
        'cut-examples',
      ]);
      this.exactly(fs.existsSync(path.join(dir2, 'package.json')), true);
      const pkg = JSON.parse(fs.readFileSync(path.join(dir2, 'package.json'), 'utf8'));
      this.exactly(pkg.name, 'answered-app');
    } finally {
      Object.defineProperty(process.stdin, 'isTTY', {
        value: wasTty,
        configurable: true,
      });
    }
    this.cleanup(tmp);
  }
}
