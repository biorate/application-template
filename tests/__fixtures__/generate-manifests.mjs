#!/usr/bin/env node
// Генерация golden-фикстур: манифесты (relPath -> sha256) для матрицы генерации.
// Запускается через runner() с теми же моками, что и интеграционные тесты,
// поэтому фикстуры соответствуют условиям тестового прогона.
import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const { runner } = require('@biorate/hygen');
import fs from 'fs';
import path from 'path';
import crypto from 'crypto';
import os from 'os';

const ROOT = path.resolve(import.meta.dirname, '..', '..');
const makeConfig = (tmpRoot, execCalls) => ({
  cwd: ROOT,
  templates: path.join(ROOT, '_templates'),
  logger: {
    ok: () => {},
    notice: () => {},
    warn: () => {},
    err: () => {},
    log: (...a) => console.error('[hygen]', ...a),
    colorful: () => {},
  },
  exec: (cmd) => execCalls.push(cmd),
  debug: process.env.HYGEN_DEBUG,
  createPrompter: () => ({ prompt: async () => ({}) }),
});

function manifest(dir, base = dir) {
  const out = {};
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) Object.assign(out, manifest(full, base));
    else {
      const rel = path.relative(base, full).replaceAll(path.sep, '/');
      out[rel] = crypto.createHash('sha256').update(fs.readFileSync(full)).digest('hex');
    }
  }
  return out;
}

const CASES = {
  cs: ['root,client,server', []],
  cl: ['root,client', []],
  sv: ['root,server', []],
  cut: ['root,client,server', ['--cut-examples']],
  ws: ['root,client,server', ['--add-web-socket']],
};

const fixturesDir = path.join(ROOT, 'tests/__fixtures__/manifests');
fs.rmSync(fixturesDir, { recursive: true, force: true });
fs.mkdirSync(fixturesDir, { recursive: true });

for (const [name, [actions, extra]] of Object.entries(CASES)) {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), `hygen-fixture-${name}-`));
  const execCalls = [];
  const result = await runner(
    [
      'create',
      actions,
      `--root=${tmp}`,
      '--app-name=ref-app',
      '--app-description=Ref app',
      ...extra,
    ],
    makeConfig(tmp, execCalls),
  );
  if (!result.success) {
    console.error(name, JSON.stringify(result, null, 2).slice(0, 3000));
    throw new Error(`fixture ${name} failed`);
  }
  fs.writeFileSync(
    path.join(fixturesDir, `${name}.json`),
    JSON.stringify(manifest(tmp), null, 2),
  );
  fs.writeFileSync(
    path.join(fixturesDir, `${name}.exec.json`),
    JSON.stringify(execCalls, null, 2),
  );
  fs.rmSync(tmp, { recursive: true, force: true });
  console.log(`${name}: ok`);
}
console.log('fixtures generated');
