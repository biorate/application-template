import { createRequire } from 'module';
import { fileURLToPath } from 'url';
import fs from 'fs';
import os from 'os';
import path from 'path';
import crypto from 'crypto';
import { UnitSpec } from './unit-spec';

const nodeRequire = createRequire(import.meta.url);
// CJS-вход: ESM-экспорт теряет фабрику хелперов при загрузке .hygen.js
const { runner } = nodeRequire('@biorate/hygen');

export const ROOT = path.resolve(
  path.dirname(fileURLToPath(import.meta.url)),
  '..',
  '..',
);
const FIXTURES = path.join(ROOT, 'tests', '__fixtures__', 'manifests');

export type Cfg = {
  cwd: string;
  templates: string;
  logger: Record<string, (...a: unknown[]) => void>;
  exec: (cmd: string) => void;
  createPrompter: () => {
    prompt: (qs: { name: string; type: string }[]) => Promise<Record<string, unknown>>;
  };
  debug?: boolean;
};

export const silentLogger = () => {
  const noop = () => {};
  return { ok: noop, notice: noop, warn: noop, err: noop, log: noop, colorful: noop };
};

export const makeConfig = (overrides: Partial<Cfg> = {}): Cfg => ({
  cwd: ROOT,
  templates: path.join(ROOT, '_templates'),
  logger: silentLogger(),
  exec: () => {},
  createPrompter: () => ({ prompt: async () => ({}) }),
  ...overrides,
});

export function manifest(dir: string): Record<string, string> {
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

export const TEMPLATES = path.join(ROOT, '_templates');

/**
 * Загружает фабрику хелперов .hygen.ts репозитория.
 */
export function loadFactory() {
  nodeRequire('ts-node/register/transpile-only');
  return nodeRequire(path.join(ROOT, '.hygen.ts'));
}

/**
 * Нормализует модуль .hygen.ts так же, как config-resolver движка 0.8.x:
 * named-экспорты приоритетны, default-класс инстанцируется, его
 * собственные перечислимые свойства становятся конфигом проекта.
 */
export function normalizeConfig(mod: Record<string, unknown>): Record<string, unknown> {
  const named = Object.keys(mod).filter((k) => k !== 'default' && k !== '__esModule');
  if (named.length > 0) return Object.fromEntries(named.map((k) => [k, mod[k]]));
  const Ctor = mod.default;
  if (typeof Ctor !== 'function') return (Ctor as object) ?? {};
  const instance = new (Ctor as new () => Record<string, unknown>)();
  if (
    typeof (instance as { toRunnerConfig?: () => Record<string, unknown> })
      .toRunnerConfig === 'function'
  ) {
    return (
      instance as { toRunnerConfig: () => Record<string, unknown> }
    ).toRunnerConfig();
  }
  return instance;
}

/**
 * Вызывает фабрику хелперов как это делает движок hygen для действия root:
 * модуль .hygen.ts нормализуется по семантике config-resolver движка
 * (named-экспорты либо default-класс, инстанцируемый движком).
 */
export function runFactory(locals: Record<string, unknown>) {
  const project = normalizeConfig(loadFactory());
  return project.helpers(
    { _: ['create', 'root'], action: 'root', ...locals },
    { templates: TEMPLATES },
  );
}

/**
 * База для интеграционных тестов генератора: обвязка runner(),
 * tmp-каталоги, манифесты и golden-фикстуры.
 */
export abstract class GeneratorSpec extends UnitSpec {
  protected readonly runner = runner;
  protected readonly fixtures = FIXTURES;

  protected tmpDir(): string {
    return fs.mkdtempSync(path.join(os.tmpdir(), 'hygen-test-'));
  }

  protected readFixture(name: string): Record<string, unknown> {
    return JSON.parse(fs.readFileSync(path.join(this.fixtures, `${name}.json`), 'utf8'));
  }

  protected cleanup(dir: string): void {
    fs.rmSync(dir, { recursive: true, force: true });
  }

  protected runCs(config: Cfg, extra: string[] = [], root?: string) {
    return runner(
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
  }
}
