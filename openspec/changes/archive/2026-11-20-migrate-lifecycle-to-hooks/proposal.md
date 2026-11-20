# Proposal

## Why

Действие `root` исполняет фиксацию жизненного цикла через шаблоны-хаки алфавитного порядка: `a-before.t` — пустой плейсхолдер (`sh: ""`) только ради позиции «в начале», `z-after.t` — prettier + chmod husky «в конце». Пост-обработка цели — ответственность root-действия, но живёт в shell-шаблоне с EJS-интерполяцией и хаком позиционирования. Движок `@biorate/hygen` имеет нативные action-хуки жизненного цикла (`afterAll` класса `hooks.ts`), делающие механизм явным.

## What Changes

- Удалены `_templates/create/root/a-before.t` (no-op) и `_templates/create/root/z-after.t`.
- В `_templates/create/root/hooks.ts` (классовая форма action-хуков) добавлен метод `afterAll(ctx, results)`: `prettier --write <root>` + `chmod ug+x <root>/.husky/*` (кроме win32) — исполняется движком единожды в конце действия root (гранулярность прежнего z-after).
- Из фабрики хелперов удалён хелпер `platform` — использовался только в `z-after.t`.
- Композиция locals не меняется: фабрика `helpers(locals, config)` остаётся механизмом трансформации CLI-аргументов в `h.*` (ROOT, APP_NAME, SERVER_NAME, CLIENT_NAME, CLIENT, SERVER, CUT_EXAMPLES, ADD_WEB_SOCKET) — это зафиксировано документацией, новый механизм не вводится.
- Документация (`AGENTS.md`, `tests/README.md`) переписана: алфавитные «точки входа» `a-before`/`z-after` больше не существуют, exec-фикстуры не содержат captured shell-команд prettier.
- Golden-фикстуры регенерируются: изменяются манифесты (нет файлов a-before/z-after) и exec-фикстуры (prettier/chmod исполняются в хуке, движком не капчуrся как `sh:`-команды).

## Capabilities

### New Capabilities

<!-- Нет новых capabilities. -->

### Modified Capabilities

- `app-generator`: добавляется требование о проектных хуках жизненного цикла — `afterAll` в `.hygen.ts` исполняет пост-обработку цели (prettier + chmod husky) один раз после всех действий; требование «Чистота фабрики хелперов» переписывается без упоминания z-after и шаблона доставки.

## Impact

- `_templates/create/root/a-before.t`, `_templates/create/root/z-after.t` — удалены.
- `.hygen.ts` — экспорт `hooks.afterAll`; хелпер `platform` удалён.
- `tests/factory.spec.ts` — при наличии упоминаний `platform`/z-after правится.
- `tests/__fixtures__/manifests/` (`*.json`, `*.exec.json`) — регенерация.
- `AGENTS.md` (разделы о структуре шаблонов и порядке исполнения), `tests/README.md` (exec-фикстуры, порядок z-after).
- Вывод генерации: содержимое файлов цели не меняется (гранулярность форматирования — как у z-after); меняется механизм исполнения (action-хук вместо shell-шаблона) — diff-матрица по sha256 фиксируется регенерацией фикстур.
- Зависимость от порядка изменений: предполагается архивация `drop-target-hygen-config` до применения (его дельта переписывает те же требования спеки).
