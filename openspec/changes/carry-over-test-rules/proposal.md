# Proposal

## Why

Проект-эталон `lmru-payment-pof-webview_event_analyse` (сгенерирован из этого шаблона) накопил более зрелые правила тестирования, чем кладёт генератор: OOP-стиль `@suite/@test`, изоляция unit-тестов от DI-контейнера, базовые Spec-классы в `tests/common/` и подробный `tests/README.md`. Правила нужно перенести обратно в шаблон, чтобы все будущие сгенерированные проекты получали их из коробки, а тесты самого генератора получили такую же аккуратную организацию и документацию.

## What Changes

- Шаблон `_templates/create/server/apps/server/AGENTS.md.t`: раздел «Тестирование» переписан по эталону — Vitest + OOP-декораторы `@suite/@test` (`@biorate/vitest-spec`), unit тестирует `application`/`domain` изолированно **без** поднятия `Root`/DI-контейнера, база — `tests/common/unit-spec.ts`, описаны слои unit/e2e и команды запуска.
- Новый шаблон `_templates/create/server/apps/server/tests/README.md.t` — гайд по тестам генерируемого приложения (стек, архитектура тестов, Spec-иерархия, паттерны по слоям, Unimock, Allure, команды); документация, флагом `--cut-examples` не режется.
- Синхронизация: правки в `tests/common/unit-spec.ts.t` и связанных шаблонах тестов, если текст правил на них ссылается.
- `tests/README.md` в этом репозитории — краткий гайд тестов генератора (factory.spec, runner.spec, golden-фикстуры, команды).
- `AGENTS.md` этого репозитория — компактный раздел «Тестирование генератора» вместо разрозненных упоминаний.

Out of scope: component-слой тестов в шаблоне (есть в эталоне, но в шаблон не переносится — отдельное решение).

## Capabilities

### New Capabilities

- `app-generator`: требования к составу и содержимому артефактов, которые генератор кладёт в сгенерированный проект (AGENTS.md, тестовая документация); расширяется требованием о переносе правил тестирования в шаблоны server-действия.

### Modified Capabilities

## Impact

- Файлы: `_templates/create/server/apps/server/AGENTS.md.t`, `_templates/create/server/apps/server/tests/README.md.t` (новый), возможно `tests/common/*.t`; `tests/README.md` (новый), `AGENTS.md` репозитория.
- Вывод генератора изменится: в сгенерированном `apps/<name>-server/` появится `tests/README.md`, изменится текст `AGENTS.md` — diff-матрица и golden-фикстуры (`tests/__fixtures__/manifests/`) потребуют регенерации.
- Зависимостей кода не касается; тесты генератора должны пройти после регенерации фикстур.
