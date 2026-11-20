# Proposal

## Why

Схема параметров генератора (`root`, `app-name`, `app-description`, `cut-examples`, `add-web-socket`) продублирована в трёх hook-файлах (`_templates/create/{root,client,server}/hooks.ts`) — одно и то же объявление `static params` повторяется трижды. Форк `@biorate/hygen@0.10.0` поддерживает глобальную декларацию `params` в проектном конфиге (`.hygen.ts`): схема задаётся один раз, движок резолвит и валидирует её до запуска действий, а конфликтов с action-level дескрипторами нет, поскольку action-level схемы из хуков удаляются.

## What Changes

- В hook-файлах `_templates/create/{root,client,server}/hooks.ts` схема параметров объявляется **instance-свойством** `params` (не `static params`) — движок `@biorate/hygen@0.10.0` читает `instance.params ?? static.params`.
- Из фабрики хелперов `.hygen.ts` глобальный член `params` **не** вводится: глобальная схема промптится движком до запуска действий (в т.ч. для мета-действия `help`) — ловушка, проверенная на практике.
- Поведение генератора не меняется: параметры по-прежнему обязательны, prompt/coercion/validation выполняет params-фаза движка per-action; `hygen create help` не запрашивает параметры.
- Тесты (`tests/factory.spec.ts`, `tests/runner.spec.ts`) обновляются: sync-тест фабрик, проверка отсутствия `params` в hook-классах, регенерация golden-фикстур (хэш `.hygen.ts` меняется).

## Capabilities

### New Capabilities

(нет)

### Modified Capabilities

- `app-generator`: требование «Классовая форма action hooks в действиях генератора» меняется — схема параметров в hook-файлах объявляется instance-свойством `params` вместо `static params`; фабрика хелперов схему параметров не объявляет (глобальный `params` в конфиге промптится даже для `help` — проверено, отклонено).

## Impact

- `.hygen.ts` — остаётся без члена `params` (глобальная схема отклонена).
- `_templates/create/{root,client,server}/hooks.ts` — `static params` → instance `params`.
- `tests/factory.spec.ts` — проверки: instance-`params` в hook-классах, отсутствие `params` в конфиге фабрики.
- Зависимости: `@biorate/hygen@0.10.0` (уже установлена, изменений версий нет).
