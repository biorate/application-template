#!/usr/bin/env bash
set -euo pipefail

# Универсальная миграция mocha -> vitest для biorate-проектов.
#
# Режимы:
#   A: только server (конфиги/тесты/зависимости внутри apps/<server>)
#   B: A + root devDependencies (vite/vitest/@biorate/vitest(-spec)/allure-vitest)  [рекомендуется]
#   C: B + инфраструктурные правки (lerna/workspaces/tsconfig root)                 [осторожно]
#
# Usage:
#   ./scripts/migrate-mocha-to-vitest.sh --server apps/my-server --mode A
#   ./scripts/migrate-mocha-to-vitest.sh --server apps/my-server --mode B
#   ./scripts/migrate-mocha-to-vitest.sh --server apps/my-server --mode C
#   ./scripts/migrate-mocha-to-vitest.sh --server apps/my-server --mode B --dry-run
#

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVER_REL=""
MODE="B"
DRY_RUN=0

log() { printf '%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] $*"
  else
    eval "$@"
  fi
}

usage() {
  cat <<'EOF'
Usage:
  migrate-mocha-to-vitest.sh --server <path> [--mode A|B|C] [--dry-run]

Options:
  --server <path>   Path to server app (has package.json, tests/)
  --mode <A|B|C>    Migration mode (default: B)
  --dry-run         Print actions without changing files
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --server)
      SERVER_REL="${2:-}"
      shift 2
      ;;
    --mode)
      MODE="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown arg: $1"
      ;;
  esac
done

[[ -n "$SERVER_REL" ]] || { usage; exit 1; }
[[ "$MODE" == "A" || "$MODE" == "B" || "$MODE" == "C" ]] || die "mode must be A|B|C"

require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Command not found: $1"; }
require_file() { [[ -f "$1" ]] || die "File not found: $1"; }

require_cmd node

SERVER_DIR="$ROOT_DIR/$SERVER_REL"
SERVER_PKG="$SERVER_DIR/package.json"
SERVER_TSCONFIG="$SERVER_DIR/tsconfig.json"
ROOT_PKG="$ROOT_DIR/package.json"
ROOT_TSCONFIG="$ROOT_DIR/tsconfig.json"
ROOT_WORKSPACE="$ROOT_DIR/pnpm-workspace.yaml"
ROOT_LERNA="$ROOT_DIR/lerna.json"

require_file "$ROOT_PKG"
require_file "$SERVER_PKG"

# Жёстко зафиксированные версии (как в референсном репо).
# Можно переопределить через env vars при необходимости.
: "${V_BIORATE_VITEST:=1.8.0}"
: "${V_BIORATE_VITEST_SPEC:=1.7.0}"
: "${V_ALLURE_VITEST:=3.7.1}"
: "${V_VITEST:=4.1.5}"
: "${V_VITE:=6.3.5}"
: "${V_SWC_NODE_REGISTER:=1.10.10}"
: "${V_UNPLUGIN_SWC:=1.5.3}"
: "${V_SUPERTEST:=6.1.6}"
: "${V_NOCK:=14.0.1}"
: "${V_REFLECT_METADATA:=0.2.2}"

log "mode=$MODE dryRun=$DRY_RUN"
log "versions: @biorate/vitest=$V_BIORATE_VITEST @biorate/vitest-spec=$V_BIORATE_VITEST_SPEC allure-vitest=$V_ALLURE_VITEST vitest=$V_VITEST vite=$V_VITE"

json_mutate() {
  local file="$1"
  local js="$2"

  if [[ "$DRY_RUN" == "1" ]]; then
    log "[dry-run] patch json: ${file#$ROOT_DIR/}"
    return 0
  fi

  node -e "
const fs = require('node:fs');
const path = '$file';
const raw = fs.readFileSync(path, 'utf8');
const json = JSON.parse(raw);
($js)(json);
fs.writeFileSync(path, JSON.stringify(json, null, 2) + '\\n');
" || die "Failed to patch JSON: $file"
}

replace_in_file() {
  local file="$1"
  local from="$2"
  local to="$3"
  [[ -f "$file" ]] || return 0

  if [[ "$DRY_RUN" == "1" ]]; then
    node -e "const fs=require('node:fs');const s=fs.readFileSync('$file','utf8');process.exit(s.includes(String($from))?0:1)" \
      && log "[dry-run] replace in ${file#$ROOT_DIR/}: $from -> $to" \
      || true
    return 0
  fi

  node -e "
const fs=require('node:fs');
const path='$file';
let s=fs.readFileSync(path,'utf8');
const from=String($from);
const to=String($to);
if (!s.includes(from)) process.exit(0);
s=s.split(from).join(to);
fs.writeFileSync(path,s);
"
}

ensure_server_vitest_config() {
  local cfg="$SERVER_DIR/vitest.config.mjs"
  if [[ -f "$cfg" ]]; then
    return 0
  fi
  log "create: ${cfg#$ROOT_DIR/}"
  if [[ "$DRY_RUN" == "1" ]]; then
    return 0
  fi
  cat >"$cfg" <<'EOF'
import { defineConfig } from 'vitest/config';
import { fileURLToPath } from 'node:url';
import swc from 'unplugin-swc';

export default defineConfig({
  esbuild: false,
  plugins: [
    swc.vite({
      sourceMaps: true,
      jsc: {
        parser: {
          syntax: 'typescript',
          decorators: true,
          dynamicImport: true,
        },
        transform: {
          legacyDecorator: true,
          decoratorMetadata: true,
          useDefineForClassFields: false,
        },
        target: 'es2022',
      },
      module: {
        type: 'es6',
      },
    }),
  ],
  resolve: {
    alias: [
      {
        find: /^@\/(.*)$/,
        replacement: fileURLToPath(new URL('./src/$1', import.meta.url)),
      },
    ],
  },
  test: {
    globals: true,
    testTimeout: 2000,
    hookTimeout: 30000,
    setupFiles: ['reflect-metadata', './tests/setup.ts'],
    reporters: [
      'default',
      ['allure-vitest/reporter', { resultsDir: 'allure-results', suiteTitle: false }],
    ],
    exclude: ['node_modules', 'dist'],
  },
});
EOF
}

remove_mocha_configs() {
  local files=(
    "$SERVER_DIR/.mocharc.json"
    "$SERVER_DIR/.nycrc.json"
    "$SERVER_DIR/.reporters.json"
  )
  for f in "${files[@]}"; do
    if [[ -f "$f" ]]; then
      log "remove: ${f#$ROOT_DIR/}"
      run "rm -f \"$f\""
    fi
  done
}

patch_server_package_json() {
  log "patch: ${SERVER_PKG#$ROOT_DIR/}"

  json_mutate "$SERVER_PKG" "
function (pkg) {
  pkg.scripts ||= {};
  pkg.dependencies ||= {};
  pkg.devDependencies ||= {};

  pkg.scripts.test = 'npx vitest run';
  if (pkg.scripts['start:debug']) {
    pkg.scripts['start:debug'] = 'cross-env npx nodemon --exec \"node --enable-source-maps -r @swc-node/register -r tsconfig-paths/register index.ts\"';
  }

  // deps
  pkg.dependencies['reflect-metadata'] ||= '$V_REFLECT_METADATA';

  // dev deps
  pkg.devDependencies['@swc-node/register'] ||= '$V_SWC_NODE_REGISTER';
  pkg.devDependencies['unplugin-swc'] ||= '$V_UNPLUGIN_SWC';
  pkg.devDependencies['supertest'] ||= '$V_SUPERTEST';
  pkg.devDependencies['nock'] ||= '$V_NOCK';

  // remove mocha/nyc stack
  const remove = [
    '@biorate/mocha',
    '@biorate/mocha-spec',
    'mocha',
    'mocha-chai-jest-snapshot',
    'mocha-multi-reporters',
    '@istanbuljs/nyc-config-typescript',
    '@types/mocha',
    'nyc'
  ];
  for (const name of remove) {
    delete pkg.devDependencies[name];
    delete pkg.dependencies[name];
  }

  // keep allure-vitest in root in mode B/C
  delete pkg.devDependencies['allure-vitest'];
}
"
}

patch_root_package_json() {
  [[ "$MODE" == "B" || "$MODE" == "C" ]] || return 0

  log "patch: ${ROOT_PKG#$ROOT_DIR/}"
  json_mutate "$ROOT_PKG" "
function (pkg) {
  pkg.devDependencies ||= {};
  pkg.devDependencies['@biorate/vitest'] ||= '$V_BIORATE_VITEST';
  pkg.devDependencies['@biorate/vitest-spec'] ||= '$V_BIORATE_VITEST_SPEC';
  pkg.devDependencies['allure-vitest'] ||= '$V_ALLURE_VITEST';
  pkg.devDependencies['vitest'] ||= '$V_VITEST';
  pkg.devDependencies['vite'] ||= '$V_VITE';
}
"
}

ensure_server_tsconfig_esmoduleinterop() {
  [[ -f "$SERVER_TSCONFIG" ]] || return 0
  log "ensure esModuleInterop: ${SERVER_TSCONFIG#$ROOT_DIR/}"
  if [[ "$DRY_RUN" == "1" ]]; then
    return 0
  fi
  node -e "
const fs=require('node:fs');
const path='$SERVER_TSCONFIG';
const raw=fs.readFileSync(path,'utf8');
const json=JSON.parse(raw);
json.compilerOptions ||= {};
if (json.compilerOptions.esModuleInterop === true) process.exit(0);
json.compilerOptions.esModuleInterop = true;
fs.writeFileSync(path, JSON.stringify(json, null, 2) + '\\n');
"
}

patch_tests_tree() {
  local tests_dir="$SERVER_DIR/tests"
  [[ -d "$tests_dir" ]] || return 0

  log "patch tests under: ${tests_dir#$ROOT_DIR/}"
  local file_list
  file_list="$(node -e "
const fs=require('node:fs');const path=require('node:path');
const root='$tests_dir';const out=[];
function walk(dir){for(const e of fs.readdirSync(dir,{withFileTypes:true})){
  const p=path.join(dir,e.name);
  if(e.isDirectory()) walk(p);
  else if(e.isFile() && (p.endsWith('.spec.ts') || p.endsWith('setup.ts') || p.endsWith('/common/spec.ts'))) out.push(p);
}}
walk(root);process.stdout.write(out.join('\\n'));
")"

  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    replace_in_file "$f" "'@biorate/mocha'" "'@biorate/vitest'"
    replace_in_file "$f" "'@biorate/mocha-spec'" "'@biorate/vitest-spec'"
    replace_in_file "$f" "'Severity'" "'severity'"

    if [[ "$f" == */tests/setup.ts ]]; then
      replace_in_file "$f" "'import { use } from \\'chai\\';\\n'" "''"
      replace_in_file "$f" "'} from \\'@biorate/mocha\\';'" "'} from \\'@biorate/vitest\\';'"
      replace_in_file "$f" "'before(async function () {'" "'beforeAll(async function () {'"
      replace_in_file "$f" "'after(async function () {});'" "'afterAll(async function () {});'"
      replace_in_file "$f" "'decorate<MochaAllure>(allure);'" "'decorate(allure);'"
      replace_in_file "$f" "'this.timeout(30000);\\n'" "''"
    fi

    if [[ "$f" == */tests/common/spec.ts ]]; then
      replace_in_file "$f" "'import { timeout } from \\'@biorate/mocha\\';\\n'" "''"
      replace_in_file "$f" "'@timeout(2000)\\n'" "''"
      replace_in_file "$f" "'import \\'../setup\\';\\n'" "''"
    fi
  done <<<"$file_list"
}

patch_root_infra_mode_c() {
  [[ "$MODE" == "C" ]] || return 0

  # workspaces patterns
  if [[ -f "$ROOT_PKG" ]]; then
    log "mode C: normalize workspaces in ${ROOT_PKG#$ROOT_DIR/}"
    json_mutate "$ROOT_PKG" "
function (pkg) {
  if (Array.isArray(pkg.workspaces)) {
    pkg.workspaces = ['apps/*', 'packages/*'];
  }
}
"
  fi

  # pnpm-workspace.yaml (best-effort text patch)
  if [[ -f "$ROOT_WORKSPACE" ]]; then
    log "mode C: normalize ${ROOT_WORKSPACE#$ROOT_DIR/}"
    replace_in_file "$ROOT_WORKSPACE" "'- apps/*/**\\n'" "'- apps/*\\n'"
    replace_in_file "$ROOT_WORKSPACE" "'- packages/*/**\\n'" "'- packages/*\\n'"
  fi

  # root tsconfig: types + target + module casing (best-effort JSON patch)
  if [[ -f "$ROOT_TSCONFIG" ]]; then
    log "mode C: patch ${ROOT_TSCONFIG#$ROOT_DIR/}"
    if [[ "$DRY_RUN" == "1" ]]; then
      log "[dry-run] patch json: ${ROOT_TSCONFIG#$ROOT_DIR/}"
    else
      node -e "
const fs=require('node:fs');
const path='$ROOT_TSCONFIG';
const raw=fs.readFileSync(path,'utf8');
const json=JSON.parse(raw);
json.compilerOptions ||= {};
json.compilerOptions.types = Array.from(new Set([...(json.compilerOptions.types||[]), 'vitest/globals', 'node']));
json.compilerOptions.target ||= 'es2020';
if (json.compilerOptions.target.toLowerCase() === 'es2017') json.compilerOptions.target = 'es2020';
fs.writeFileSync(path, JSON.stringify(json,null,2)+'\\n');
"
    fi
  fi

  # lerna.json is repo-specific; do not rewrite automatically, only warn
  if [[ -f "$ROOT_LERNA" ]]; then
    log "mode C note: lerna.json changes are repo-specific; not auto-patching."
  fi
}

main() {
  log "root: $ROOT_DIR"
  log "server: ${SERVER_DIR#$ROOT_DIR/}"

  patch_root_package_json
  patch_server_package_json
  ensure_server_tsconfig_esmoduleinterop
  ensure_server_vitest_config
  remove_mocha_configs
  patch_tests_tree
  patch_root_infra_mode_c

  log "done."
  log "next:"
  log "  - pnpm i"
  log "  - pnpm -C ${SERVER_REL} test"
}

main

