# Spec Delta

## Purpose

Определяет, какие артефакты правил тестирования генератор кладёт в сгенерированный server-проект: раздел «Тестирование» в AGENTS.md и гайд тестов в tests/README.md.

## ADDED Requirements

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
