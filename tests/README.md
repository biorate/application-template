# Тестирование генератора

Тесты репозитория `application-template` проверяют сам генератор: фабрику
хелперов `.hygen.js` и интеграцию с `@biorate/hygen`.

## 🧰 Стек

| Инструмент                 | Назначение                                                |
| -------------------------- | --------------------------------------------------------- |
| **Vitest**                 | Тест-раннер (`pnpm test`)                                 |
| **`@biorate/vitest`**      | OOP-декораторы `@suite()`/`@test()`                       |
| **`@biorate/vitest-spec`** | Базовый класс `Spec`, `this.exactly()` (deep equality)    |
| **`@biorate/hygen`**       | Embedding API `runner(argv, config)` — генерация в тестах |
| **`allure-vitest`**        | Allure-репорты (`allure-results/`)                        |

## 🗂 Структура

```
tests/
+-- common/
|   +-- unit-spec.ts             <- UnitSpec: база без поднятия приложения
|   +-- generator-spec.ts        <- GeneratorSpec: обвязка runner() (конфиг,
|                                    tmp-каталоги, манифесты, фикстуры)
+-- factory.spec.ts              <- юнит-тесты фабрики .hygen.js
+-- runner.spec.ts               <- интеграционные тесты через runner()
+-- __fixtures__/
    +-- generate-manifests.mjs   <- регенерация golden-фикстур
    +-- manifests/
        +-- {cs,cl,sv,cut,ws}.json        <- манифесты (relPath -> sha256)
        +-- {cs,cl,sv,cut,ws}.exec.json   <- captured shell-команды (z-after и др.)
```

## 🧬 Spec-иерархия

Как в сгенерированных проектах, тесты строятся на базовых классах:

- **`UnitSpec`** (`tests/common/unit-spec.ts`) — extends `Spec` из `@biorate/vitest-spec`,
  `httpServer = null`: приложение не поднимается. Общая база всех spec'ов генератора.
- **`GeneratorSpec`** (`tests/common/generator-spec.ts`) — extends `UnitSpec`; несёт
  интеграционную обвязку: `this.runner` (CJS-вход `@biorate/hygen`), `this.tmpDir()`,
  `this.readFixture(name)`, `this.runCs()`, `this.cleanup()`; наружу также экспортирует
  `makeConfig` / `silentLogger` / `manifest` / `ROOT`.

## 🧪 Что тестируется

### `factory.spec.ts` — фабрика `.hygen.js` (extends `GeneratorSpec`)

- Деривация `CLIENT`/`SERVER` из списка действий (`root,client,server`, подмножества, неизвестные действия).
- Валидация обязательных флагов (`--root`, `--app-name`, `--app-description`).
- Guard: точное совпадение `realpath(--root)` с корнем репозитория — запрет; вложенные пути и несуществующие каталоги — разрешены.
- Действие `help` пропускает валидацию.
- Синхронность `.hygen.js` и `root/.hygen.js.t`.

### `runner.spec.ts` — интеграция через `runner()` (extends `GeneratorSpec`)

- **Golden-матрица**: 5 кейсов (`cs`=root,client,server; `cl`=root,client; `sv`=root,server; `cut`=`--cut-examples`; `ws`=`--add-web-socket`) сравниваются с фикстурами по sha256-манифестам и captured exec-командам.
- Websocket-файлы генерируются только в server-поддереве.
- Порядок: `z-after.t` (prettier + chmod husky на linux) — последним в exec.
- Негативы: без `--root` / без `--app-name` — `success: false`, ноль записанных файлов.
- Guard: генерация в корень репозитория запрещена.
- Идемпотентность: повторный прогон — ноль `added`.
- `prompt.js`: non-TTY — без вопросов; TTY — только missing-параметры, программные ответы доходят до фабрики.

## 🔧 Регенерация golden-фикстур

Фикстуры генерируются тем же `runner()` с теми же моками (silent logger, mock exec, empty prompter), что и тесты — форматирование prettier на сравнение не влияет:

```bash
node tests/__fixtures__/generate-manifests.mjs
```

Регенерация обязательна после любого изменения шаблонов `_templates/create/`.

## 🚀 Команды

```bash
pnpm test            # все тесты генератора
pnpm test -- tests/factory.spec.ts   # только фабрика
npx tsc --noEmit -p tsconfig.json    # типизация тестов
```
