# Spec Delta

## ADDED Requirements

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

## MODIFIED Requirements

### Requirement: Чистота фабрики хелперов

Фабрика хелперов `.hygen.ts` репозитория-шаблона MUST использовать именованный экспорт `export const helpers` (контракт движка: `export default` ломает резолв — резолвер спредит namespace модуля) и MUST быть отформатирована repo-prettier. Хелпер `platform` в фабрике не существует — условие платформы вычисляется в action-хуке `afterAll` действия root средствами Node.js; проектные экспорты хуков в конфиге не объявляются.

#### Scenario: Синхронность фабрик и контракт экспорта

- **WHEN** инспекция `.hygen.ts` репозитория-шаблона
- **THEN** фабрика содержит именованный экспорт `helpers` и не содержит экспорта `hooks`; хелпер `platform` отсутствует; шаблон `_templates/create/root/$ROOT$/.hygen.ts.t` отсутствует
