# Tasks

## 1. Правила тестирования в шаблоне server (B — основной)

- [x] 1.1 Переписать раздел «Тестирование» в `_templates/create/server/apps/server/AGENTS.md.t` по эталону: Vitest + OOP-декораторы `@suite`/`@test` (`@biorate/vitest-spec`); unit покрывает `application`/`domain` изолированно, без поднятия `Root`/DI-контейнера; база — `tests/common/unit-spec.ts`; слои unit/e2e с setup-файлами и Unimock; команды `pnpm test`, `pnpm test:unit`, `pnpm test:e2e`, `pnpm test:e2e:record`; ссылка на `tests/README.md`.
- [x] 1.2 Создать `_templates/create/server/apps/server/tests/README.md.t` — гайд по структуре эталонного `tests/README.md` (стек и инструменты, архитектура тестов, Spec-иерархия: Spec/`UnitSpec`, паттерны unit по слоям, Unimock запись/воспроизведение, Allure, команды запуска), без ClickHouse- и component-специфики, с дисклеймером о развитии гайда проектом; `to:` без гейта `CUT_EXAMPLES`.
- [x] 1.3 Проверить согласованность: все файлы, упомянутые в AGENTS.md.t и README.md.t, реально генерируются шаблонами (`tests/common/unit-spec.ts.t`, `tests/unit/setup.ts.t`, `tests/e2e/setup.ts.t`, `tests/__mocks__/e2e.ts.t`); при расхождениях — минимальные правки шаблонов или текста правил.

## 2. Документация тестов генератора (A — лёгкая форма)

- [x] 2.1 Создать `tests/README.md`: стек (vitest, `@biorate/vitest`, `@biorate/vitest-spec`), назначение `tests/factory.spec.ts` (юнит-тесты фабрики `.hygen.js`) и `tests/runner.spec.ts` (интеграция через `runner()` против golden-фикстур), устройство и регенерация `tests/__fixtures__/manifests/` (`node tests/__fixtures__/generate-manifests.mjs`), команда `pnpm test`.
- [x] 2.2 Добавить в корневой `AGENTS.md` компактный раздел «Тестирование генератора» (3–5 строк: что тестируем, `pnpm test`, ссылка на `tests/README.md`) и убрать/ужать разрозненные упоминания тестов в других разделах.

## 3. Верификация

- [x] 3.1 Регенерировать golden-фикстуры: `node tests/__fixtures__/generate-manifests.mjs`; убедиться, что в манифестах появились `apps/ref-app-server/tests/README.md` и обновлённые AGENTS.md.
- [x] 3.2 Прогнать `pnpm test` — все 20 тестов зелёные (golden-матрица валидирует согласованность шаблонов и фикстур).
- [x] 3.3 Diff-проверка CLI: сгенерировать `root,server` и `root,client,server --cut-examples`, убедиться, что `tests/README.md` присутствует в обоих случаях и текст AGENTS.md соответствует новым правилам.
- [x] 3.4 Прогнать `npx tsc --noEmit -p tsconfig.json` (документация не должна сломать типизацию) и `git status` — мусор не закоммичен.
