# Proposal

## Why

`@biorate/hygen` 0.5.x предоставляет декларативную схему параметров (`static params` на классе hook-модуля: дескрипторы `name`/`type`/`required`/`default`/`message`), которая берёт на себя coercion CLI-флагов, генерацию промптов для недостающих required-параметров и post-prompt валидацию. Сейчас эта логика размазана императивно по трём одинаковым `hooks.ts` (ручной `missing`-фильтр, ручная сборка вопросов, TTY-guard), а неинтерактивная политика живёт в hook-коде, тогда как движок предоставляет для неё нативную точку — `createPrompter` в конфиге (резолвер спредит конфиг поверх дефолта CLI, `createPrompter` из `.hygen.ts` перекрывает `() => require('enquirer')`).

Отдельный мотив — безопасность params-фазы в CI: эмпирически проверено, что enquirer 2.3.6 в non-TTY не резолвится и не бросает, а висит; TTY-guard'а у params-фазы в 0.5.1 нет. Нативное решение — TTY-aware `createPrompter` в `.hygen.ts`: в non-TTY возвращается stub-промптер, params-фаза завершается чистой ошибкой `ParamRequiredError` вместо зависания.

## What Changes

- Три `_templates/create/{root,client,server}/hooks.ts` мигрируют с императивного `prompt()` на декларативную форму 0.5.1: класс с `static params` из пяти required-дескрипторов (`root`, `app-name`, `app-description` — string; `cut-examples`, `add-web-socket` — boolean, required, `default: false`). Required-статус boolean-флагов сохраняет TTY-confirm'ы (params-фаза спрашивает только required); в non-TTY контракт «все флаги явно» остаётся, нарушивший его получает `ParamRequiredError` вместо hang.
- `.hygen.ts` (и её байт-синхронная копия `root/$ROOT$/.hygen.ts.t`) дополняется экспортом `createPrompter`: TTY → enquirer, non-TTY → stub `{ prompt: async () => ({}) }`. TTY-guard в hooks.ts удаляется — неинтерактивная политика переезжает в единственное место (конфиг) и покрывает заодно params-фазу.
- `enquirer` добавляется прямым devDep репозитория (pnpm strict-hoisting: транзитивный `require('enquirer')` из конфига не резолвится).
- Фабрика хелперов (именованный экспорт `helpers`, derived-хелперы `h.*`, guard) не меняется по поведению; валидация required в фабрике остаётся как defense-in-depth (до неё в CI не доходит — params-фаза падает раньше).
- Тесты: `runner.spec.ts` (non-TTY интеграционный кейс ожидает чистую ошибку params-валидации, титулы), `factory.spec.ts` (sync-тест без изменений по сути), golden-фикстуры регенерируются (хэш доставляемого `.hygen.ts` меняется).
- Документация: `AGENTS.md` — декларативная форма hooks, `createPrompter`-гейт, требование enquirer.

## Capabilities

### New Capabilities

(нет)

### Modified Capabilities

- `app-generator`: требование «Классовая форма action hooks в действиях генератора» меняется — hook-модули объявляют параметры декларативно через `static params` (императивный `prompt()` удаляется), неинтерактивный режим обеспечивается TTY-gate в `createPrompter` конфига фабрики, а не guard'ом в hook-коде.

## Impact

- Код: `_templates/create/{root,client,server}/hooks.ts`, `.hygen.ts`, `_templates/create/root/$ROOT$/.hygen.ts.t` (байт-синхронно), `tests/{runner,factory}.spec.ts` (частично), `tests/__fixtures__/manifests/*` (регенерация), `package.json` (devDep `enquirer`), `AGENTS.md`.
- Зависимости: `enquirer` — новый прямой devDep (транзитивный через `@biorate/hygen` уже в lockfile).
- Поведение: TTY-UX идентичен (те же 4 вопроса); результат генерации побайтово идентичен вне доставляемого `.hygen.ts`; текст CI-ошибки при пропущенных флагах меняется с `[--x] is not defined` (фабрика) на `ParamRequiredError` (params-валидация).
- Риски/ограничения: сгенерированная цель получает `.hygen.ts` с `createPrompter`; TTY-ветка лениво требует `enquirer` — цели, запускающие генератор в TTY, должны иметь его зависимостью (сейчас цели генератор не запускают). Отклонённая альтернатива — ждать TTY-guard в core (`promptFromParams`): блокирует миграцию без нужды, нативное решение доступно через конфиг.
