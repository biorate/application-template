# Spec Delta

## MODIFIED Requirements

### Requirement: Классовая форма action hooks в действиях генератора

Каждое действие генератора (`root`, `client`, `server`) MUST содержать hook-файл в классовой TS-форме `hooks.ts` (дефолт-экспорт класса), объявляющий параметры генерации декларативно через статический член `static params` — массив дескрипторов (`name`, `type`, `required`, `default`, `message`) в форме `@biorate/hygen` >= 0.5.1. Все параметры генератора (`root`, `app-name`, `app-description` — string; `cut-examples`, `add-web-socket` — boolean) MUST быть объявлены `required` с осмысленными `message`; boolean-флаги — с `default: false`. Императивный метод `prompt()` (ручной missing-фильтр, ручная сборка вопросов, TTY-guard) в hook-модулях отсутствует: coercion флагов, промпт недостающих required-параметров в TTY и post-prompt валидацию выполняет params-фаза движка.

#### Scenario: Интерактивный ввод недостающих параметров

- **WHEN** запуск `hygen create` в TTY без флагов `--app-name`/`--app-description`/`--cut-examples`/`--add-web-socket`
- **THEN** params-фаза запрашивает только недостающие required-параметры (string — input, boolean — confirm с initial из `default`), ответы становятся переменными шаблонов; переданные флаги не переспрашиваются и приводятся к объявленному типу

#### Scenario: Не-интерактивный режим

- **WHEN** запуск в non-TTY (CI) без части флагов
- **THEN** stub-промптер конфига (см. требование неинтерактивного режима) не отвечает, params-фаза завершается ошибкой `ParamRequiredError` с именем параметра; зависания промптера нет

#### Scenario: Некорректный тип флага

- **WHEN** флаг передан в значении, не приводимом к объявленному типу (например `--cut-examples=maybe`)
- **THEN** params-фаза завершается ошибкой coercion, называющей параметр и ожидаемый тип

## ADDED Requirements

### Requirement: Неинтерактивный режим через createPrompter конфига

Фабрика хелперов (`.hygen.ts` и её байт-синхронный шаблон `.hygen.ts.t`) MUST экспортировать `createPrompter` — TTY-aware фабрику промптеров: TTY → промптер enquirer, non-TTY → stub с методом `prompt`, возвращающим пустой объект. Конфиговый экспорт перекрывает дефолт CLI и применяется движком ко всем фазам промпта, включая params-фазу.

#### Scenario: TTY использует enquirer

- **WHEN** генерация запущена в интерактивном терминале
- **THEN** `createPrompter` возвращает промптер enquirer, params-фаза рендерит вопросы

#### Scenario: non-TTY не вызывает enquirer

- **WHEN** генерация запущена в CI (stdin/stdout не TTY)
- **THEN** `createPrompter` возвращает stub, enquirer не инстанцируется, params-фаза завершается валидационной ошибкой без зависания

#### Scenario: Синхронность фабрик с гейтом

- **WHEN** инспекция `.hygen.ts` и шаблона фабрики
- **THEN** обе фабрики содержат идентичный `createPrompter`-экспорт, содержимое фабрик байт-в-байт синхронно (sync-тест в `factory.spec.ts`)
