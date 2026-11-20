# Tasks

## 1. Эталонный вывод старого генератора

- [x] 1.1 Из рабочего состояния (до правок, текущий HEAD) сгенерировать эталон в `tmp/ref-old/` для матрицы: `--client --server`, только `--client`, только `--server`, `--client --server --cut-examples`, `--client --server --add-web-socket` (каждый прогон с `--app-name=ref-app --app-description='Ref app' --root=tmp/ref-old/<case>`). Зафиксировать наборы файлов (`find`-манифест) для каждого случая.
- [x] 1.2 Проверить, что `tmp/` присутствует в `.gitignore` репозитория; при отсутствии — добавить.

Примечание: эталонная матрица фиксирует вывод старых флагов `--client`/`--server`; в новой системе те же случаи выражаются списком действий (`root,client` ≡ старый `--client`, и т.д.) — соответствие в 6.1.

## 2. Структура каталогов и расширения

- [x] 2.1 Создать `_templates/create/{root,client,server,help}/`; перенести файлы `git mv` из `_templates/app/create/` и `_templates/app/help/` по распределению: root-файлы (по прежним префиксам: config-подготовка, корневые конфиги, README, LICENSE, after-all) → `root/`; файлы `apps_client_*` → `client/apps/client/` с зеркальной иерархией (`src/`, `tests/`, `view/` и т.д.); `apps_server_*` → `server/apps/server/` (`src/app/{domain,application,infrastructure}/`, `migrations/`, `locales/`); тестовые шаблоны `tests_*` (00164–00180) → `server/tests/`; `_templates/app/help/index.ejs.t` → `create/help/index.t`.
- [x] 2.2 Переименовать все `.ejs.t` → `.t` и снять числовые префиксы `NNNNN.MM_` (кроме переименований `00001` → `a-before.t`, `00183`+`00184` → `z-after.t` с объединением содержимого).
- [x] 2.3 Удалить `_templates/app/` (пустой после переноса) и `_templates/create/00000…config`-остаток (конфиг переезжает в `.hygen.js`, см. 3.x).

## 3. `.hygen.js` — фабрика хелперов, guard, валидация

- [x] 3.1 Переписать `.hygen.js`: `module.exports.helpers = (locals, config) => ({...})` — обязательный `--root` (throw при отсутствии), вычисление `ROOT`, `APP_NAME`, `APP_DESCRIPTION`, `SERVER_NAME`, `CLIENT_NAME`, `CUT_EXAMPLES`, `ADD_WEB_SOCKET`; деривация `CLIENT`/`SERVER` из позиционного списка действий (`locals._[1].split(',')`); возврат всех значений как хелперов (`h.*`), плюс `_`, `stringify`, `root`, `defined`, `platform`.
- [x] 3.2 Реализовать guard точного совпадения: `realpath(--root) === realpath(dirname(config.templates))` → throw до любых вычислений/записи.
- [x] 3.3 Реализовать валидацию обязательных `--app-name`, `--app-description` (текст ошибки в формате `[--app-name] is not defined`, как в текущем `h.defined`).
- [x] 3.4 Убрать хелперы `server`, `client`, `hygen` из `.hygen.js`.

## 3a. prompt.js — интерактивные параметры

- [x] 3a.1 Создать `_templates/create/root/prompt.js`, `client/prompt.js`, `server/prompt.js` (по D9): TTY-guard (не-TTY → `{}`), вопросы только о недостающих `app-name`, `app-description`, `cut-examples`, `add-web-socket`; `--root`, `client`, `server` не спрашиваются.
- [x] 3a.2 Убедиться, что промпт-значения доходят до фабрики хелперов (locals) и до шаблонов — smoke-прогон в TTY с частично переданными флагами.

## 4. Переписывание шаблонов на h.\* и чистка to:

- [x] 4.1 Во всех шаблонах заменить использования конфигурационных переменных на `h.*`: `${ROOT}` → `${h.ROOT}`, `${SERVER_NAME}` → `${h.SERVER_NAME}`, `${CLIENT_NAME}` → `${h.CLIENT_NAME}`, `${APP_NAME}` → `${h.APP_NAME}`, `${APP_DESCRIPTION}` → `${h.APP_DESCRIPTION}`, условия `SERVER`/`CLIENT`/`HYGEN`/`CUT_EXAMPLES`/`ADD_WEB_SOCKET` → `h.SERVER`/`h.CLIENT`/`h.CUT_EXAMPLES`/`h.ADD_WEB_SOCKET`.
- [x] 4.2 Выпилить гейты из `to:` (~181 место): `h.server(...)`/`h.client(...)` → безусловное выражение; `h.hygen(...)` в `root/.hygen.js.t` → безусловный `to:`.
- [x] 4.3 В `root/package.json.t` (бывш. 00017) заменить гейт `"hygen": "6.2.11"` на безусловный `"@biorate/hygen": "^0.1.0"`; удалить все прочие ветки `HYGEN ? … : …`.
- [x] 4.4 Содержимое `root/.hygen.js.t` (бывш. 00006) заменить на копию новой фабрики из `.hygen.js` (D5), без гейтов `server`/`client`/`hygen`.
- [x] 4.5 Проверить `h.platform` в `root/z-after.t`: prettier --write `<h.ROOT>` + на linux `chmod ug+x <h.ROOT>/.husky/*`; никаких строк удаления файлов.
- [x] 4.6 Обновить `create/help/index.t`: действия root/client/server, обязательный `--root`, флаги без `--hygen`.

## 5. Документация и служебное

- [x] 5.1 README.md: новая команда-пример `npx hygen create root,client,server --root=… …`, таблица флагов без `--hygen`, пометка об обязательности `--root`.
- [x] 5.2 AGENTS.md: синхронно обновить команды, структуру `_templates/create/…`, убрать упоминания нумерации/`renumerate-templates.js`/`--hygen`; зафиксировать правило «шаблоны никогда не удаляются из цели».
- [x] 5.3 Удалить `.scripts/renumerate-templates.js`.

## 6. Верификация

- [x] 6.1 Матрица diff: сгенерировать `tmp/ref-new/` теми же 5 случаями через `hygen create root,client,server`; `diff -r` против `tmp/ref-old/` — расхождения только ожидаемые: `.hygen.js` в цели (новая фабрика), корневой `package.json` (`@biorate/hygen` вместо гейта `hygen 6.2.11`); манифесты файлов совпадают.
- [x] 6.2 Подмножества действий: `hygen create client …` и `hygen create root,server …` — генерируются только соответствующие поддеревья; повторный прогон того же подмножества в ту же папку не портит уже созданные файлы (`unless_exists`-поведение сохранено).
- [x] 6.3 Негативные сценарии: без `--root` → ошибка до записи; без `--app-name`/`--app-description` → ошибка валидации; `--root=<корень репо>` → guard-ошибка до записи; `--root=tmp/guard-ok` внутри репо → успешная генерация.
- [x] 6.4 Smoke `hygen create help` — справка соответствует структуре; `hygen --version` работает.
- [x] 6.5 Прогон smoke на целевой платформе (linux): порядок a-before/z-after соблюдён — `.husky/*` исполняемые, сгенерированный код отформатирован prettier (в diff-эталоне это уже видно, зафиксировать явно).
- [x] 6.6 Прогнать генерацию с `--add-web-socket` и убедиться, что websocket-файлы (gateways, dto, events) попали только в серверное поддерево.

## 7. Тестовая инфраструктура и тесты (@biorate/vitest + @biorate/vitest-spec)

- [x] 7.1 Добавить devDeps: `@biorate/vitest`, `@biorate/vitest-spec`, `vitest`, `reflect-metadata`, `allure-js-commons`, `allure-vitest`; корневой `vitest.config.mjs` по паттерну monorepo biorate (`globals: true`, `setupFiles: ['reflect-metadata']`, allure-репортер) и каталог `tests/`; скрипт `test` в `package.json`.
- [x] 7.2 Юнит-тесты фабрики `.hygen.js` (`@suite`-классы): деривация `CLIENT`/`SERVER` из списка действий (`root,client,server`, подмножества, неизвестные действия), валидация (`--root`, `--app-name`, `--app-description`), guard (точное совпадение realpath — throw; вложенные пути — ок).
- [x] 7.3 Golden-фикстуры: сгенерировать манифесты деревьев + хэши ключевых файлов для матрицы 6.1, положить в `tests/__fixtures__/` (после успешной ручной верификации 6.1).
- [x] 7.4 Интеграционные тесты через `runner()` (`Spec`-классы, `this.exactly()` против golden-фикстур): матрица действий/флагов с mock `exec`, capture `logger`, mock `createPrompter`; `tmp/`-каталоги на каждый тест (создание/очистка в lifecycle-хуках).
- [x] 7.5 Тесты prompt.js: TTY-стаб + mock-промптер — перехват вопросов (только missing), программные ответы доходят до фабрики; не-TTY → без вопросов, фабрика валидирует.
- [x] 7.6 Тесты порядка: mock `exec` фиксирует `a-before`-пустоту, `z-after`-команды (prettier, chmod на linux) последними; негативные сценарии через `runner` (`success:false`, ноль записанных файлов).
- [x] 7.7 Идемпотентность: двойной `runner` в одну папку — `unless_exists`-файлы не перезаписаны (статусы `skipped`).

## 8. Завершение

- [x] 8.1 Финальный `git status` — в репо не осталось следов старой структуры (`_templates/app/`), мусор `tmp/ref-*` не закоммичен.
- [x] 8.2 Коммит по Conventional Commits (`feat!:` — breaking: новая команда, обязательный `--root`, удалены `--hygen`, `--client`, `--server`).
