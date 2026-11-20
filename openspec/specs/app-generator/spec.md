# app-generator Specification

## Purpose

Поведение генератора приложений `hygen create` (репозиторий-шаблон application-template): комбинируемые действия `root,client,server`, конфигурация и валидация через фабрику хелперов `.hygen.js`, вывод целевых путей шаблонов из их расположения (mirror + path macros), условная генерация файлов через атрибут `skip:`, неизменность результата генерации против golden-фикстур.

## Requirements

### Requirement: Вывод пути записи из расположения шаблона (mirror)

Шаблон-файл, чей целевой путь однозначно выводится из его собственного расположения в дереве `_templates/`, MUST объявлять `mirror: true` вместо атрибута `to:`. Целевой путь в этом случае равен относительному пути шаблона от корня действия с подстановкой path-макросов `$IDENTIFIER$` в сегментах пути; суффикс `.t` срезается до подстановки.

#### Scenario: Путь с макросами имени приложения

- **WHEN** шаблон `_templates/create/client/apps/$CLIENT_NAME$/src/view/consts.tsx.t` рендерится с параметром `--app-name=my-app` в действии `client`
- **THEN** файл записывается в `<root>/apps/my-app-client/src/view/consts.tsx`, и фронтматтер шаблона не содержит `to:`

#### Scenario: Абсолютный префикс через макрос ROOT

- **WHEN** root-шаблон `_templates/create/root/$ROOT$/package.json.t` рендерится с `--root=<root>`
- **THEN** файл записывается в `<root>/package.json`

#### Scenario: Неразрешимый идентификатор

- **WHEN** в имени папки шаблона присутствует макрос `$UNKNOWN$`, не резолвимый из контекста прогона
- **THEN** генерация падает с ошибкой `PathMacroResolutionError`, называющей шаблон, сегмент и идентификатор

### Requirement: Условная генерация через атрибут skip

Условная генерация файла (зависимость от действий `client`/`server`, флагов `--cut-examples`, `--add-web-socket`) MUST выражаться атрибутом `skip:`, а не условным `to:`. Рендер `skip:` в truthy-значение пропускает действие без записи и без ошибки.

#### Scenario: Примеры вырезаются флагом

- **WHEN** шаблон `_templates/create/server/apps/$SERVER_NAME$/tests/unit/...spec.ts.t` рендерится с флагом `--cut-examples`
- **THEN** действие пропускается (в логе — `skipped` с причиной), файл не создаётся, ошибки нет

#### Scenario: Действие server без клиента

- **WHEN** client-зависимый root-шаблон (например `.stylelintrc.json.t`) рендерится в составе действий `root,server` без `client`
- **THEN** действие пропускается через `skip:`, файл в цели не создаётся

### Requirement: Явный to: для нетривиальных путей

Шаблон, чей целевой путь не выводится из расположения (переносы, копирование `from:`, нестандартные преобразования), MAY сохранять явный `to:`. Явный `to:` MUST иметь приоритет над `mirror: true`.

#### Scenario: Приоритет to:

- **WHEN** шаблон объявляет одновременно `to:` и `mirror: true`
- **THEN** запись выполняется по пути из `to:`, зеркалирование игнорируется

### Requirement: Сохранение генерируемого результата

Состав файлов сгенерированной цели определяется исключительно шаблонами действий: для любой комбинации действий и флагов состав, расположение и содержимое файлов цели MUST оставаться идентичными golden-фикстурам; `.hygen.ts` в цель не доставляется и в манифестах фикстур не фигурирует.

#### Scenario: Golden-фикстуры

- **WHEN** интеграционный прогон генерации (`pnpm test`)
- **THEN** diff-матрица пуста; в сгенерированной цели отсутствует `.hygen.ts`; dep `@biorate/hygen` в корневом `package.json` сохраняется (для догенерации шаблонов в цели)

### Requirement: Классовая форма action hooks в действиях генератора

Каждое действие генератора (`root`, `client`, `server`) MUST содержать hook-файл в классовой TS-форме `hooks.ts` (дефолт-экспорт класса), объявляющий параметры генерации декларативно через **instance-свойство** `params` (не `static params`) — массив дескрипторов (`name`, `type`, `required`, `default`, `message`) в форме `@biorate/hygen` >= 0.10.0. Все параметры генератора (`root`, `app-name`, `app-description` — string; `cut-examples`, `add-web-socket` — boolean) MUST быть объявлены `required` с осмысленными `message`; boolean-флаги — с `default: false`. Фабрика хелперов (`.hygen.ts`) MUST НЕ объявлять глобальный член `params`: глобальная схема промптится движком до запуска действий, включая мета-действие `help`. Императивный метод `prompt()` (ручной missing-фильтр, ручная сборка вопросов, TTY-guard) в hook-модулях отсутствует: coercion флагов, промпт недостающих required-параметров в TTY и post-prompt валидацию выполняет params-фаза движка по схеме действия.

#### Scenario: Интерактивный ввод недостающих параметров

- **WHEN** запуск `hygen create` в TTY без флагов `--app-name`/`--app-description`/`--cut-examples`/`--add-web-socket`
- **THEN** params-фаза по схеме действия запрашивает только недостающие required-параметры (string — input, boolean — confirm с initial из `default`), ответы становятся переменными шаблонов; переданные флаги не переспрашиваются и приводятся к объявленному типу

#### Scenario: Не-интерактивный режим

- **WHEN** запуск в non-TTY (CI) без части флагов
- **THEN** stub-промптер конфига не отвечает, params-фаза завершается ошибкой `ParamRequiredError` с именем параметра; зависания промптера нет

#### Scenario: Некорректный тип флага

- **WHEN** флаг передан в значении, не приводимом к объявленному типу (например `--cut-examples=maybe`)
- **THEN** params-фаза завершается ошибкой coercion, называющей параметр и ожидаемый тип

#### Scenario: Instance-объявление вместо static

- **WHEN** инспекция `_templates/create/{root,client,server}/hooks.ts`
- **THEN** каждый hook-класс объявляет instance-свойство `params` с дескрипторами всех пяти параметров, статический член `static params` отсутствует

#### Scenario: Мета-действие help без параметров

- **WHEN** выполняется `hygen create help`
- **THEN** параметры генерации не запрашиваются: действие `help` не имеет hook-файла с `params` (глобальная схема в конфиге промптировала бы и для `help` — потому отклонена)

#### Scenario: Фабрика без глобальной схемы

- **WHEN** инспекция `.hygen.ts`
- **THEN** фабрика не объявляет член `params` (схемы живут только в hook-файлах действий)

### Requirement: Чистота фабрики хелперов

Фабрика хелперов `.hygen.ts` репозитория-шаблона MUST использовать именованный экспорт `export const helpers` (контракт движка: `export default` ломает резолв — резолвер спредит namespace модуля) и MUST быть отформатирована repo-prettier. Хелпер `platform` в фабрике не существует — условие платформы вычисляется в action-хуке `afterAll` действия root средствами Node.js; проектные экспорты хуков в конфиге не объявляются.

#### Scenario: Синхронность фабрик и контракт экспорта

- **WHEN** инспекция `.hygen.ts` репозитория-шаблона
- **THEN** фабрика содержит именованный экспорт `helpers` и не содержит экспорта `hooks`; хелпер `platform` отсутствует; шаблон `_templates/create/root/$ROOT$/.hygen.ts.t` отсутствует

### Requirement: Неинтерактивный режим через createPrompter конфига

Фабрика хелперов `.hygen.ts` репозитория-шаблона MUST экспортировать `createPrompter` — TTY-aware фабрику промптеров: TTY → промптер enquirer, non-TTY → stub с методом `prompt`, возвращающим пустой объект. Конфиговый экспорт перекрывает дефолт CLI и применяется движком ко всем фазам промпта, включая params-фазу.

#### Scenario: TTY использует enquirer

- **WHEN** генерация запущена в интерактивном терминале
- **THEN** `createPrompter` возвращает промптер enquirer, params-фаза рендерит вопросы

#### Scenario: non-TTY не вызывает enquirer

- **WHEN** генерация запущена в CI (stdin/stdout не TTY)
- **THEN** `createPrompter` возвращает stub, enquirer не инстанцируется, params-фаза завершается валидационной ошибкой без зависания

#### Scenario: Синхронность фабрик с гейтом

- **WHEN** инспекция `.hygen.ts` репозитория-шаблона
- **THEN** фабрика содержит экспорт `createPrompter`; шаблон `_templates/create/root/$ROOT$/.hygen.ts.t` отсутствует

### Requirement: Правила тестирования в AGENTS.md сгенерированного сервера

`apps/<app-name>-server/AGENTS.md`, сгенерированный действием `server`, ДОЛЖЕН (SHALL) содержать раздел «Тестирование», который фиксирует: OOP-стиль декораторов `@suite`/`@test` (`@biorate/vitest-spec`); изоляцию unit-тестов от `Root`/DI-контейнера; базу `tests/common/unit-spec.ts`; слои unit/e2e; команды `pnpm test:unit`, `pnpm test:e2e`, `pnpm test:e2e:record`, `pnpm test`.

#### Scenario: Генерация server-действия создаёт обновлённый AGENTS.md

- **WHEN** выполняется `hygen create root,server --root=<dir> --app-name=<name> --app-description=<desc>`
- **THEN** в `<dir>/apps/<name>-server/AGENTS.md` есть раздел «Тестирование», упоминающий OOP-декораторы `@suite`/`@test`, изоляцию unit от DI-контейнера, базу `tests/common/unit-spec.ts` и команды `pnpm test:unit` / `pnpm test:e2e`

#### Scenario: Текст правил соответствует фактическим шаблонам тестов

- **WHEN** шаблоны `tests/common/*` и конфиги `vitest.*.config.mjs` генерируются вместе с AGENTS.md
- **THEN** упомянутые в правилах файлы (`tests/common/unit-spec.ts`, `tests/unit/setup.ts`, `tests/e2e/setup.ts`, `tests/__mocks__/e2e.ts`) реально создаются генератором

### Requirement: Гайд тестов в tests/README.md сгенерированного сервера

`apps/<app-name>-server/tests/README.md`, сгенерированный действием `server`, ДОЛЖЕН (SHALL) содержать документацию по тестам: стек и инструменты, архитектуру тестов (соответствие слоям гексагональной архитектуры), базовые Spec-классы, паттерны unit-тестирования по слоям, Unimock (запись/воспроизведение), Allure-отчёты и команды запуска. Гайд является документацией и не удаляется флагом `--cut-examples`.

#### Scenario: Генерация server-действия создаёт гайд тестов

- **WHEN** выполняется `hygen create root,server --root=<dir> --app-name=<name> --app-description=<desc>`
- **THEN** в `<dir>/apps/<name>-server/tests/README.md` есть разделы о стеке, архитектуре тестов, Spec-иерархии, Unimock и командах запуска

#### Scenario: Гайд не режется флагом cut-examples

- **WHEN** выполняется генерация с флагом `--cut-examples`
- **THEN** `apps/<name>-server/tests/README.md` присутствует в выводе

### Requirement: Документация тестов генератора в репозитории шаблона

Репозиторий шаблона ДОЛЖЕН (SHALL) содержать `tests/README.md`, документирующий собственные тесты генератора: юнит-тесты фабрики `.hygen.js`, интеграционные тесты через `runner()`, golden-фикстуры и их регенерацию, команду `pnpm test`. Корневой `AGENTS.md` ДОЛЖЕН содержать компактный раздел «Тестирование генератора», ссылающийся на этот гайд.

#### Scenario: Документация тестов генератора актуальна

- **WHEN** читается `tests/README.md` репозитория шаблона
- **THEN** перечислены оба spec-файла, назначение golden-фикстур, команда их регенерации и команда `pnpm test`

### Requirement: Action-хук afterAll для пост-обработки корня цели

Action-хуки действия `root` (`_templates/create/root/hooks.ts`, классовая форма) MUST объявлять метод `afterAll`, который движок исполняет единожды в конце действия root: форматирование `prettier --write <root>` и, на платформах кроме win32, установку исполняемых битов `<root>/.husky/*`. При упавшей генерации (guard, валидация) или пустом результате действия пост-обработка не исполняется.

#### Scenario: Форматирование в конце действия root

- **WHEN** выполняется `hygen create root[,client][,server] --root=<dir> ...`
- **THEN** после записи файлов действия root его `afterAll` форматирует `prettier --write` корень цели

#### Scenario: chmod husky вне Windows

- **WHEN** генерация выполняется на linux/macOS и в цели создан `.husky/`
- **THEN** файлам `<dir>/.husky/*` установлены исполняемые биты; на win32 chmod не исполняется

#### Scenario: Отсутствие шаблонов-хаков жизненного цикла

- **WHEN** инспекция `_templates/create/root/`
- **THEN** файлов `a-before.t` и `z-after.t` нет; captured exec-команды фикстур не содержат prettier/chmod

#### Scenario: Упавшая генерация без пост-обработки

- **WHEN** действие root завершается без записанных файлов (guard, валидация параметров)
- **THEN** `afterAll` не исполняет prettier и chmod
