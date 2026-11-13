---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/tests/README.md` %>
unless_exists: true
---
# Тестирование `<%= h.SERVER_NAME %>`

> Стартовый гайд по тестам. Проект развивает его по мере роста тестовой suite —
> дополняйте паттерны разделов 4–5 реальными примерами из этого репозитория.

## 📋 Содержание

1. [Стек и инструменты](#-стек-и-инструменты)
2. [Архитектура тестов](#-архитектура-тестов)
3. [Базовые классы (Spec hierarchy)](#-базовые-классы-spec-hierarchy)
4. [Unit-тесты](#-unit-тесты)
5. [E2E-тесты](#-e2e-тесты)
6. [Конфигурационные файлы](#-конфигурационные-файлы)
7. [Команды запуска](#-команды-запуска)
8. [Allure-отчёты](#-allure-отчёты)
9. [Правила и соглашения](#-правила-и-соглашения)

---

## 🧰 Стек и инструменты

| Инструмент | Назначение |
|---|---|
| **Vitest** | Тест-раннер (быстрее Jest, совместим с Vite/SWC) |
| **`@biorate/vitest`** | OOP-декораторы `@suite()`, `@test()` вместо `describe`/`it` |
| **`@biorate/vitest-spec`** | Базовый класс `Spec` с интеграцией DI-контейнера |
| **`@biorate/unimock`** | Запись/воспроизведение вызовов внешних сервисов (для E2E) |
| **`vitest` (`vi`)** | Встроенные моки (`vi.fn()`, `vi.useFakeTimers()`) |
| **`supertest`** | HTTP-тестирование (для E2E) |
| **`allure-vitest`** | Allure-репортинг с декораторами |
| **`unplugin-swc`** | Транспиляция TS с декораторами и metadata |

---

## 🏗 Архитектура тестов

Тесты следуют **слоистой архитектуре** приложения (hexagonal):

```
src/app/
+-- shared/             -> чистые функции (тест без DI)
+-- domain/             -> VO, Params (тест без DI)
+-- application/        -> Use Cases (моки портов)
+-- infrastructure/
    +-- http/in/        -> Controllers (test double subclass)
    +-- persistence/    -> pure function / fake timers
    +-- bootstrap/      -> Root (E2E)

tests/
+-- common/
|   +-- common-spec.ts  <- базовый Spec с Root из контейнера
|   +-- unit-spec.ts    <- UnitSpec (httpServer = null)
+-- unit/               <- unit-тесты (изолированно)
+-- e2e/                <- e2e-тесты (приложение поднято)
+-- __mocks__/
|   +-- e2e.ts          <- моки внешних коннекторов (Unimock)
+-- unit/setup.ts       <- beforeAll для unit
+-- e2e/setup.ts        <- beforeAll/afterAll для e2e
```

---

## 🧬 Базовые классы (Spec hierarchy)

### `Spec` (`@biorate/vitest-spec`)

Базовый класс от библиотеки. Предоставляет `supertest` для HTTP-запросов.

### `CommonSpec` (`tests/common/common-spec.ts`)

```typescript
import { container } from '@biorate/inversion';
import { Spec } from '@biorate/vitest-spec';
import { Root } from '@/app/infrastructure/bootstrap';

export abstract class CommonSpec extends Spec {
  protected root: Root = container.get<Root>(Root);

  protected get httpServer() {
    return this.root.application.app.getHttpServer();
  }
}
```

- Получает `Root` из DI-контейнера
- Предоставляет `httpServer` для supertest
- Используется для **E2E** (где приложение поднято)

### `UnitSpec` (`tests/common/unit-spec.ts`)

```typescript
import { Spec } from '@biorate/vitest-spec';

export abstract class UnitSpec extends Spec {
  protected get httpServer() {
    return null; // HTTP-сервер не поднимаем
  }
}
```

- **httpServer = null** — приложение не запускается
- Все unit-тесты наследуются от `UnitSpec`
- Тесты в `UnitSpec` — **изолированные**, без DI

---

## 🧪 Unit-тесты

Unit-тесты покрывают `application`/`domain`/`infrastructure` **изолированно, без
поднятия `Root`/DI-контейнера**. Зависимости (порты) мокаются вручную.

### Паттерны по слоям

| Слой | Когда писать | Подход |
|---|---|---|
| `shared` | чистые функции (утилиты, хелперы, мапперы) | вызов функции + проверка результата |
| `domain` | Params (наследники `AutoObject`), VO, entity | валидация входов, ошибки |
| `application` | use case'ы, зависящие от портов | ручные моки портов через `vi.fn()` |
| `infrastructure/http` | NestJS-контроллеры | test double subclass контроллера |
| `infrastructure/persistence` | pure function, кэши | pure function / `vi.useFakeTimers()` |

### Пример: Use Case с моками портов

```typescript
import { suite, test } from '@biorate/vitest';
import { expect, vi } from 'vitest';
import { UnitSpec } from '../../common/unit-spec';
import { UserCreateUseCase } from '@/app/application/service';
import type { UserDrivenPort } from '@/app/application/port';

@suite('UserCreateUseCase', { mode: 'parallel' })
class UserCreateUseCaseSpec extends UnitSpec {
  @test('calls repository and returns its result')
  protected async execute() {
    const repository: UserDrivenPort = {
      create: vi.fn().mockResolvedValue({ id: 1 }),
      // неиспользуемые методы порта — vi.fn() без реализации
    };
    const useCase = new UserCreateUseCase(repository as never);

    const result = await useCase.execute(/* params */);

    expect(result).toEqual({ id: 1 });
    expect(repository.create).toHaveBeenCalledTimes(1);
  }
}
```

**Проверки:**
- результат вызова `useCase.execute(params)`
- факт вызова порта и его аргументы

---

## 🧪 E2E-тесты

E2E-тесты поднимают приложение целиком (`Root.$run()`) и ходят по HTTP через
supertest. База — `CommonSpec`.

### Setup приложения

**Файл:** `tests/e2e/setup.ts` — старт `Root` в `beforeAll`, остановка в `afterAll`.

### Unimock (запись/воспроизведение)

**Файл:** `tests/__mocks__/e2e.ts`

Вызовы внешних сервисов (коннекторы) записываются и воспроизводятся, чтобы e2e
не зависели от реальных внешних систем:

```bash
# воспроизведение (по умолчанию, CI)
UNIMOCK=replay pnpm test:e2e

# запись снапшотов
UNIMOCK=record UNIMOCK_STRIP_REQUEST=1 UNIMOCK_GZIP=1 pnpm test:e2e:record
```

Чтобы замокать коннектор — оберните его класс `@Mockable()` (см. комментарии
в `tests/__mocks__/e2e.ts`).

---

## ⚙️ Конфигурационные файлы

| Файл | Назначение |
|---|---|
| `vitest.base.mjs` | общая база: SWC-трансформация, алиасы путей |
| `vitest.unit.config.mjs` | unit: timeout 2s, параллельный запуск, setup `tests/unit/setup.ts` |
| `vitest.e2e.config.mjs` | e2e: timeout 10s, последовательный запуск, setup `tests/e2e/setup.ts` |

---

## 🚀 Команды запуска

```bash
pnpm test            # все тесты (unit + e2e)
pnpm test:unit       # только unit
pnpm test:e2e        # e2e (Unimock replay)
pnpm test:e2e:record # e2e с записью Unimock-снапшотов
```

---

## 📊 Allure-отчёты

Allure-репорты генерируются автоматически (`allure-vitest`, результаты в
`allure-results/`). Просмотр:

```bash
npx allure serve allure-results --clean -o allure-report
```

Декораторы `@epic`, `@feature`, `@owner`, `@tag`, `@description` из
`@biorate/vitest` наполняют отчёт структурой (см. пример в
`tests/e2e/probes.e2e.spec.ts`).

---

## 📏 Правила и соглашения

- OOP-стиль: `@suite`/`@test` из `@biorate/vitest`, никакого `describe`/`it`.
- Unit-тесты **не поднимают** DI-контейнер и HTTP-сервер — наследуются от `UnitSpec`.
- Моки портов — только через `vi.fn()`; все методы порта объявлены.
- E2E-тесты наследуются от `CommonSpec` и не мокают внутренности приложения.
- Внешние вызовы в e2e — только через Unimock (replay в CI, record — локально).
- Имена spec-файлов: `<unit>.spec.ts`, рядом с тестируемым слоем в `tests/unit/<layer>/`.
