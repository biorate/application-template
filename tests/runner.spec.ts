import { suite, test } from '@biorate/vitest';
import { Spec } from '@biorate/vitest-spec';
import { createRequire } from 'module';
import fs from 'fs';
import os from 'os';
import path from 'path';
import crypto from 'crypto';

const require = createRequire(import.meta.url);
// CJS-вход: ESM-экспорт теряет фабрику хелперов при загрузке .hygen.js
const { runner } = require('@biorate/hygen');

const ROOT = path.resolve(__dirname, '..');
const FIXTURES = path.join(ROOT, 'tests', '__fixtures__', 'manifests');

type Cfg = {
  cwd: string;
  templates: string;
  logger: Record<string, (...a: unknown[]) => void>;
  exec: (cmd: string) => void;
  createPrompter: () => { prompt: (qs: unknown[]) => Promise<Record<string, unknown>> };
  debug?: boolean;
};

const silentLogger = () => {
  const noop = () => {};
  return { ok: noop, notice: noop, warn: noop, err: noop, log: noop, colorful: noop };
};

const makeConfig = (overrides: Partial<Cfg> = {}): Cfg => ({
  cwd: ROOT,
  templates: path.join(ROOT, '_templates'),
  logger: silentLogger(),
  exec: () => {},
  createPrompter: () => ({ prompt: async () => ({}) }),
  ...overrides,
});

function manifest(dir: string): Record<string, string> {
  const out: Record<string, string> = {};
  const walk = (d: string) => {
    for (const entry of fs.readdirSync(d, { withFileTypes: true })) {
      const full = path.join(d, entry.name);
      if (entry.isDirectory()) walk(full);
      else
        out[path.relative(dir, full).split(path.sep).join('/')] = crypto
          .createHash('sha256')
          .update(fs.readFileSync(full))
          .digest('hex');
    }
  };
  walk(dir);
  return out;
}

const tmpDir = () => fs.mkdtempSync(path.join(os.tmpdir(), 'hygen-test-'));

const runCs = async (config: Cfg, extra: string[] = [], root?: string) =>
  runner(
    [
      'create',
      'root,client,server',
      `--root=${root ?? config.cwd}`,
      '--app-name=ref-app',
      '--app-description=Ref app',
      ...extra,
    ],
    config,
  );

@suite('Runner (integration)')
class RunnerSpec extends Spec {
  protected get httpServer() {
    return null;
  }

  @test('full matrix matches golden fixtures')
  async 'golden-matrix'() {
    for (const [name, [actions, extra]] of Object.entries({
      cs: ['root,client,server', []],
      cl: ['root,client', []],
      sv: ['root,server', []],
      cut: ['root,client,server', ['--cut-examples']],
      ws: ['root,client,server', ['--add-web-socket']],
    })) {
      const tmp = tmpDir();
      const execCalls: string[] = [];
      const result = await runner(
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
      const fixture = JSON.parse(
        fs.readFileSync(path.join(FIXTURES, `${name}.json`), 'utf8'),
      );
      this.exactly(manifest(tmp), fixture, `${name}: manifest`);
      const execFixture = JSON.parse(
        fs.readFileSync(path.join(FIXTURES, `${name}.exec.json`), 'utf8'),
      );
      this.exactly(execCalls.length, execFixture.length, `${name}: exec calls count`);
      fs.rmSync(tmp, { recursive: true, force: true });
    }
  }

  @test('websocket files are generated only in the server subtree')
  async 'websocket-only-server'() {
    const tmp = tmpDir();
    await runCs(makeConfig(), ['--add-web-socket'], tmp);
    const wsFiles = manifest(tmp);
    const gateways = Object.keys(wsFiles).filter(
      (f) => f.includes('websocket') || f.includes('gateway'),
    );
    this.exactly(gateways.length > 0, true);
    this.exactly(
      gateways.every((f) => f.includes('-server')),
      true,
    );
    fs.rmSync(tmp, { recursive: true, force: true });
  }

  @test('z-after (prettier, chmod husky on linux) is executed last')
  async 'order-z-after-last'() {
    const tmp = tmpDir();
    const execCalls: string[] = [];
    await runner(
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
    fs.rmSync(tmp, { recursive: true, force: true });
  }

  @test('missing --root fails without writing files')
  async 'negative-missing-root'() {
    const tmp = tmpDir();
    const logs: string[] = [];
    const logger = {
      ...silentLogger(),
      log: (...a: unknown[]) => logs.push(a.join(' ')),
    };
    const result = await runner(
      ['create', 'root', '--app-name=ref-app', '--app-description=Ref app'],
      makeConfig({ logger }),
    );
    this.exactly(result.success, false);
    this.exactly(fs.existsSync(path.join(tmp, 'package.json')), false);
    this.exactly(logs.join('\n').includes('[--root] is not defined'), true);
    fs.rmSync(tmp, { recursive: true, force: true });
  }

  @test('missing --app-name and --app-description fails')
  async 'negative-missing-name'() {
    const tmp = tmpDir();
    const logs: string[] = [];
    const logger = {
      ...silentLogger(),
      log: (...a: unknown[]) => logs.push(a.join(' ')),
    };
    const result = await runner(
      ['create', 'root', `--root=${tmp}`],
      makeConfig({ logger }),
    );
    this.exactly(result.success, false);
    this.exactly(
      logs.join('\n').includes('[--app-name], [--app-description] is not defined'),
      true,
    );
    fs.rmSync(tmp, { recursive: true, force: true });
  }

  @test('guard: generation into the template repository itself is forbidden')
  async 'guard-repo-root'() {
    const tmp = tmpDir();
    const logs: string[] = [];
    const logger = {
      ...silentLogger(),
      log: (...a: unknown[]) => logs.push(a.join(' ')),
    };
    const result = await runner(
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
    fs.rmSync(tmp, { recursive: true, force: true });
  }

  @test('idempotency: second run skips everything')
  async idempotency() {
    const tmp = tmpDir();
    const first = await runCs(makeConfig(), [], tmp);
    this.exactly(first.success, true);
    const before = manifest(tmp);
    const added: string[] = [];
    const logger = {
      ...silentLogger(),
      ok: (msg: string) => msg.includes('added') && added.push(msg),
    };
    const second = await runCs(makeConfig({ logger }), [], tmp);
    this.exactly(second.success, true);
    // шелл-опы (a-before/z-after) исполняются всегда, файлы — не перезаписываются
    this.exactly(added.length, 0);
    this.exactly(manifest(tmp), before);
    fs.rmSync(tmp, { recursive: true, force: true });
  }

  @test('prompt.js in non-TTY mode asks nothing; factory validates')
  async 'prompt-non-tty'() {
    const tmp = tmpDir();
    const questions: unknown[] = [];
    const config = makeConfig({
      cwd: tmp,
      createPrompter: () => ({
        prompt: async (qs: unknown[]) => (questions.push(...qs), {}),
      }),
    });
    // non-TTY по умолчанию в тестовой среде
    const result = await runner(['create', 'root', `--root=${tmp}`], config);
    this.exactly(result.success, false);
    this.exactly(questions.length, 0);
    fs.rmSync(tmp, { recursive: true, force: true });
  }

  @test('prompt.js in TTY mode asks only about missing params; answers reach the factory')
  async 'prompt-tty'() {
    const tmp = tmpDir();
    const wasTty = (process.stdin as unknown as { isTTY?: boolean }).isTTY;
    Object.defineProperty(process.stdin, 'isTTY', { value: true, configurable: true });
    try {
      const questions: { name: string }[] = [];
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
      // все флаги переданы -> вопросов не должно быть
      const dir1 = path.join(tmp, 'full');
      const r1 = await runner(
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
      // app-name/app-description переданы; confirm-вопросы про флаги — по дизайну D9
      this.exactly(questions.map((q) => q.name).sort(), [
        'add-web-socket',
        'cut-examples',
      ]);

      // без флагов -> вопросы только о missing (root не спрашивается)
      questions.length = 0;
      const dir2 = path.join(tmp, 'partial');
      const r2 = await runner(['create', 'root,client', `--root=${dir2}`], config);
      this.exactly(r2.success, true);
      // prompt.js вызывается на каждое действие (root, client) — сравниваем уникальные имена
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
    fs.rmSync(tmp, { recursive: true, force: true });
  }
}
