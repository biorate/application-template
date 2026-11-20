# Spec Delta

## MODIFIED Requirements

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
