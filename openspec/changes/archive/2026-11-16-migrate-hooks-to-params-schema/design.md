# Design

## Context

Генератор на `@biorate/hygen` 0.5.1. Три одинаковых `hooks.ts` содержат императивный `prompt()`: missing-фильтр по CLI-args, ручную сборку вопросов, TTY-guard (`if (!process.stdin.isTTY) return {}`). Неинтерактивную валидацию выполняет фабрика `.hygen.ts` (`[--x] is not defined`). Эмпирически установлено (зонд enquirer 2.3.6, stdin=/dev/null): в non-TTY enquirer не резолвится и не бросает — висит; TTY-guard'а у params-фазы движка нет (`isInteractive()` гейтит только zero-positional picker). Нативная точка переопределения — `createPrompter` в `RunnerConfig`: `bin.ts` задаёт дефолт `() => require('enquirer')`, а `config-resolver` спредит `.hygen.*`-конфиг последним, поэтому конфиговый `createPrompter` перекрывает дефолт и движок вызывает его для всех фаз промпта (`engine.ts` → `prompt(config.createPrompter, ...)` → `promptFromParams(schema, createPrompter, args)`).

## Goals / Non-Goals

- Goals: декларативная форма hooks (0.5.x target shape); сохранение TTY-UX (4 вопроса, включая confirm'ы); CI-безопасность без изменений core; побайтовая идентичность генерации вне доставляемого `.hygen.ts`.
- Non-Goals: `argCase: 'upper-underscore'` (отдельное изменение с широким blast radius: ключи locals, фабрика, тесты); правки core (`promptFromParams` TTY-guard — отдельный апстрим-предложение, не блокер); изменение состава/текстов шаблонов.

## Decisions

### D1. `static params` вместо императивного `prompt()`

Форма 0.5.1: `static params` — статический член дефолт-экспортируемого класса (модульный `export const params` движком не читается). Все пять параметров — `required`: string'и без значимых default; boolean'ы с `default: false` (initial confirm'а). Альтернатива «boolean'ы опционально» отвергнута: params-фаза не спрашивает опциональные — TTY-confirm'ы были бы потеряны. Метод `prompt()` из hook-классов удаляется: при непустом `params` он всё равно шорт-катится.

### D2. TTY-гейт в `createPrompter` (конфиг), а не в hooks

```ts
export const createPrompter = () =>
  process.stdin.isTTY && process.stdout.isTTY
    ? require('enquirer')()
    : { prompt: async () => ({}) };
```

Неинтерактивная политика переезжает из hook-кода в конфиг — единственное место, покрывающее и params-фазу, и любые будущие промпт-пути. В non-TTY stub возвращает `{}` → `promptFromParams` берёт `initial`/undefined → `validateParams` → `ParamRequiredError` (чистая ошибка, без hang). Проверка обоих TTY (stdin и stdout) — зеркально `isInteractive()` движка.

### D3. `enquirer` — прямой devDep

pnpm strict-hoisting: транзитивный enquirer не резолвится из корня (подтверждено). `require('enquirer')` в конфиге требует прямой зависимости. Lazy-вызов только в TTY-ветке — non-TTY цель без enquirer не падает на этапе загрузки конфига.

### D4. Фабрика не упрощается

Derived-хелперы (`CLIENT`, `SERVER_NAME`, `stringify`, `defined`, `platform`) и guard (запрет рендера в корень шаблона, ресолв предка для несуществующего `--root`) остаются — их params-схема не заменяет. Валидация required в фабрике сохраняется как defense-in-depth: в CI до неё не доходит (params-фаза падает раньше), но она страхует embedder-вызовы `runner()` с кастомным prompter'ом, минующим params-фазу.

### D5. Тексты ошибок меняются — принимаем

CI с пропущенными флагами: `[--app-name] is not defined` (фабрика) → `ParamRequiredError` (params-валидация). Сообщение остаётся громким и быстрым; фабричный текст остаётся живым для embedder-пути (D4).

### D6. Исправление guard'а фабрики (выявлено на diff-матрице)

Guard, добавленный в change `modernize-hygen-hooks`, разрешал несуществующий `--root` через ресолв ближайшего существующего предка и сравнивал его с родителем `_templates`. Это ложно запрещало легальную вложенную генерацию (например `sandbox/tmp/e1`, когда `sandbox/tmp/` ещё не существует: предок вырождался в корень песочницы). Тест `guard-nested` маскировал баг существующим `tmp/`. Исправление: запрещается только точное совпадение пути `--root` с корнем репозитория шаблона; несуществующий путь сверяется по строке, существующий — через `realpathSync` (symlink на корень тоже ловится). Синхронно в `.hygen.ts` и `.hygen.ts.t`.

## Risks / Trade-offs

- **[Доставляемый конфиг тянет `enquirer`]** Цель, запускающая генератор в TTY, должна иметь enquirer зависимостью. Сейчас цели генератор не запускают; при появлении такой потребности — добавить enquirer в `package.json.t`. → Принято, зафиксировано в AGENTS.md.
- **[Stub-промптер отвечает `{}` для любых вопросов]** В non-TTY это и есть желаемое поведение; в TTY stub не используется. Тест non-TTY интеграционного прогона фиксирует отсутствие hang и наличие ошибки.
- **[Поведение промпта в повторных парях]** `root,client,server`: params-фаза выполняется на каждую пару действия; недостающие required спросятся на каждой паре (как и раньше с `prompt()`). Не регрессия, а сохранение существующего поведения.

## Migration Plan

1. devDep `enquirer` → 2. `createPrompter` в `.hygen.ts` + синхронизация `.hygen.ts.t` (prettier-форматирование тела, байт-синхронно) → 3. миграция трёх `hooks.ts` на `static params` → 4. тесты (титулы, non-TTY кейс на `ParamRequiredError`) → 5. регенерация golden-фикстур (хэш `.hygen.ts` меняется) → 6. `AGENTS.md` → 7. верификация: `pnpm test`, diff-матрица 16 комбинаций против эталонов HEAD (ожидаемая дельта — только содержимое доставляемого `.hygen.ts`), ручная TTY-проверка промптов.

## Open Questions

- Апстрим-предложение в core (TTY-guard в `promptFromParams` + уточнение docstring `isInteractive`) — вне скоупа этого change, оформить отдельно после мерджа.
