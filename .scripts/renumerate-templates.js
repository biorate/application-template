#!/usr/bin/env node
/**
 * Перенумеровывает префиксы Hygen-шаблонов в каталоге в последовательность
 * `00000.00_…`, `00001.00_…`, … в **лексикографическом порядке имён файлов**
 * (как `ls | sort`), сохраняя суффикс после префикса вида `NNNNN` или `NNNNN.MM` / `NNNNN.MM.NN`.
 *
 * Использование:
 *   node .scripts/renumerate-templates.js [каталог]
 *   node .scripts/renumerate-templates.js --dry-run [каталог]
 *
 * По умолчанию каталог: `_templates/app/create` относительно текущей рабочей директории
 * (ожидается запуск из корня репозитория `application-template`).
 */
const fs = require('fs');
const path = require('path');
const argv = require('minimist')(process.argv.slice(2), { boolean: ['dry-run', 'dryRun'] });

const cwd = process.cwd();
const dryRun = argv['dry-run'] || argv.dryRun;
const positional = argv._;
const dirArg = positional[0];
const dir = path.resolve(cwd, dirArg || '_templates/app/create');

/** Префикс: 5 цифр, затем ноль или больше групп `.две_цифры` */
const PREFIX_RE = /^(\d{5}(?:\.\d{2})*)_(.+)$/;

function pad5(n) {
  const s = String(n);
  return s.length >= 5 ? s : '0'.repeat(5 - s.length) + s;
}

function parseTemplateFile(name) {
  const m = name.match(PREFIX_RE);
  if (!m) return null;
  return { prefix: m[1], suffix: m[2], full: name };
}

function main() {
  if (!fs.existsSync(dir) || !fs.statSync(dir).isDirectory()) {
    console.error(`Not a directory: ${dir}`);
    process.exit(1);
  }

  const entries = fs.readdirSync(dir);
  const files = entries
    .filter((name) => {
      const p = path.join(dir, name);
      return fs.statSync(p).isFile() && parseTemplateFile(name);
    })
    .sort((a, b) => a.localeCompare(b, 'en'));

  if (files.length === 0) {
    console.log('No matching template files.');
    return;
  }

  const plan = files.map((oldName, i) => {
    const { suffix } = parseTemplateFile(oldName);
    const newName = `${pad5(i)}.00_${suffix}`;
    return { from: oldName, to: newName };
  });

  const changes = plan.filter((p) => p.from !== p.to);
  if (changes.length === 0) {
    console.log(`Nothing to do (${files.length} template files already aligned).`);
    return;
  }

  console.log(`Directory: ${dir}`);
  console.log(`Templates: ${files.length}, renames: ${changes.length}${dryRun ? ' (dry-run)' : ''}\n`);

  if (dryRun) {
    for (const { from, to } of plan) {
      if (from !== to) console.log(`${from}\n  -> ${to}\n`);
    }
    return;
  }

  const stageDir = path.join(cwd, `.renumerate-stage-${process.pid}`);
  fs.mkdirSync(stageDir, { recursive: true });

  try {
    for (let i = 0; i < plan.length; i++) {
      fs.renameSync(path.join(dir, plan[i].from), path.join(stageDir, pad5(i)));
    }
    for (let i = 0; i < plan.length; i++) {
      fs.renameSync(path.join(stageDir, pad5(i)), path.join(dir, plan[i].to));
    }
  } finally {
    fs.rmSync(stageDir, { recursive: true, force: true });
  }

  console.log(`Done: ${changes.length} files renamed (${files.length} total).`);
}

main();
