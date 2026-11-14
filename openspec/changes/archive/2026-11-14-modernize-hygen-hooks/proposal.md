# Proposal

## Why

`@biorate/hygen@0.4.0` ввёл классовую форму action hooks (`hooks.*` с секцией `prompt()` и lifecycle-методами) и ленивый резолв hook helpers. В репозитории-шаблоне остались артефакты старой модели: три идентичные legacy-копии `prompt.js`, мёртвый `minimist`-парсинг в фабрике хелперов и шаблон `.hygen.js.t`, который из-за отсутствия frontmatter никогда не рендерился — `.hygen.js` не доставляется в сгенерированные цели, вопреки документации. Удобно привести всё к современным механизмам движка — в полном TS («вариант B»: `hooks.ts` + `.hygen.ts` с типизацией).

## What Changes

- Миграция 3× legacy `prompt.js` (root/client/server, байт-в-байт идентичны) в современную классовую форму `hooks.ts` (дефолт-экспорт класса, async-метод `prompt({ prompter, args })`, самодостаточные минимальные интерфейсы — `@biorate/hygen` не ре-экспортирует типы ActionHooks/Prompter; та же логика: TTY → только недостающие параметры, non-TTY → без вопросов).
- Миграция фабрики хелперов: `.hygen.js` удалён (git rm), вместо него `.hygen.ts` — TS-фабрика с **именованным экспортом** `export const helpers = (locals, config) => {...}` (важно: `export default` ломает движок — резолвер спредит namespace модуля; для `.hygen.js` это скрывал cjs-interop, ошибка была `createPrompter is not a function`).
- Доставка фабрики в цели: `_templates/create/root/$ROOT$/.hygen.ts.t` имеет frontmatter `mirror: true` + `unless_exists: true`, тело байт-в-байт синхронно с `.hygen.ts` — `.hygen.ts` создаётся в сгенерированных репозиториях (устраняет расхождение с AGENTS.md и golden-фикстурами); есть sync-тест в `tests/factory.spec.ts`.
- Зависимости: в devDeps репозитория добавлен `ts-node@^10.9.2`, `typescript` даунгрейден `^7.0.2` → `^5.0.4` (ts-node@10.9.2 несовместим с TS7: `TypeError: Cannot read properties of undefined (reading 'fileExists')` на `ts.sys`). В шаблоне цели (`package.json.t`) уже были `ts-node@10.9.2` + `typescript@5.0.4`.
- Фикс guard'а фабрики (латентный баг): несуществующий `--root` разрешён — путь ресолвится к ближайшему существующему предку перед `realpathSync` (раньше падал realpath ENOENT; старые тесты маскировали это грязным /tmp).
- Файлы `.hygen.ts` и `hooks.ts` отформатированы repo-prettier, чтобы доставленная копия была байт-в-байт идентична (prettier в `z-after.t` переформатирует цель).
- Обновление тестов (`factory.spec.ts` — suite «Factory (.hygen.ts helpers)», sync-тест `.hygen.ts.t`, `loadFactory` через `ts-node/register/transpile-only`; `runner.spec.ts` — тесты на `hooks.ts`; `common/generator-spec.ts` — loadFactory) и документации (`AGENTS.md`).
- Регенерация golden-фикстур: манифесты дополняются хэшем `.hygen.ts` (осознанное изменение вывода генерации, +1 файл в цели).
- **BREAKING** для потребителей шаблона: сгенерированный репозиторий теперь содержит `.hygen.ts` (файл, обязанный быть по документации).

## Capabilities

### New Capabilities

<!-- Нет новых capabilities. -->

### Modified Capabilities

- `app-generator`: (а) action hooks в действиях генератора — классовая TS-форма `hooks.ts` вместо legacy `prompt.js`; (б) доставка TS-фабрики хелперов `.hygen.ts` в сгенерированную цель становится реальным требованием (сейчас файл не создаётся).

## Impact

- `_templates/create/{root,client,server}/prompt.js` — удалены; `_templates/create/{root,client,server}/hooks.ts` — новые (класс, дефолт-экспорт, async `prompt()`).
- `.hygen.js` — удалён (git rm); новый `.hygen.ts` — TS-фабрика с именованным экспортом `export const helpers`; `_templates/create/root/$ROOT$/.hygen.ts.t` — новая доставка фабрики в цель (frontmatter `mirror: true` + `unless_exists: true`, байт-в-байт синхронно с `.hygen.ts`).
- `package.json` (devDeps): добавлен `ts-node@^10.9.2`, `typescript` `^7.0.2` → `^5.0.4`.
- `.hygen.ts` и `hooks.ts` отформатированы repo-prettier (для байт-в-байт синхронности доставленной копии).
- Guard фабрики: ресолв несуществующего `--root` к ближайшему существующему предку перед `realpathSync`.
- `tests/factory.spec.ts` (suite «Factory (.hygen.ts helpers)», sync-тест, `loadFactory` через `ts-node/register/transpile-only`), `tests/runner.spec.ts` (тесты на `hooks.ts`), `tests/common/generator-spec.ts` (loadFactory); `tests/__fixtures__/manifests/*` — регенерация.
- `AGENTS.md` — обновление правил (hook-файлы, доставка `.hygen.ts`, окружение ts-node/typescript@5.0.4).
