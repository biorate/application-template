---
unless_exists: false
force: true
mirror: true
---
# 🏛️ SERVER: NestJS + Inversify + гексагональная архитектура (`<%= h.SERVER_NAME %>`)

## 📐 Слои (строгое разделение)

- `src/app/domain/` — сущности, VO, доменные события, ошибки (`domain/error/*`). **Ноль** зависимостей от фреймворков.
- `src/app/application/` — driven-порты (`application/port/`), use-case’ы, сервисы сценариев. Зависит от `domain`, не от Nest/HTTP. Use-case — **обычные классы** (порты в `constructor`), без `@Injectable()` и без `@biorate/inversion`; регистрация в `AppModule` через `useFactory` / `inject`.
- `src/app/infrastructure/` — Nest-контроллеры, репозитории, внешние клиенты, WebSocket (если включены), `shared/`, `logger.ts`, привязки Inversify; **`bootstrap/`** — контейнер и класс HTTP-приложения.

## 🔌 DI (Inversify + Nest)

- `@biorate/inversion` (контейнер, `@inject`, токены `Types`) — в `infrastructure/` (в т.ч. `infrastructure/bootstrap/`, адаптеры). В **`domain`** и **`application`** не разноси инфраструктурные детали DI.
- NestJS `@Injectable()` — **только** в `infrastructure` (контроллеры, middleware, провайдеры репозиториев и т.п.).
- Контейнер и класс `Root`: `src/app/infrastructure/bootstrap/root-config.ts`. Класс HTTP-приложения: `src/app/infrastructure/bootstrap/application.ts`. Точка входа: `src/index.ts` (`container.get(Root).$run()`). Не смешивай разные контейнеры.
- Порты сценариев объявляются в **`application/port/`**. Реализации портов биндятся в **`infrastructure`** (часто в `AppModule` и/или через `Types.*`).

## 🌐 Статика (SPA)

`ServeStaticModule` в `src/app/index.ts`: при раздаче **нескольких** фронтов сначала регистрируй **узкий** префикс (например `serveRoot: '/admin'` для сборки админки), затем клиент с корня `/` — иначе catch-all клиента перехватит префикс. Перед деплоем собери фронты (`pnpm run build` / скрипты монорепо).

## 🧪 Тестирование

- Тест-раннер: **Vitest** + OOP-стиль `@biorate/vitest-spec` (декораторы `@suite`/`@test` вместо `describe`/`it`).
- **Unit** (`tests/unit/`): тестируем `application`/`domain` изолированно, **без** поднятия `Root`/DI-контейнера.
  - База: `tests/common/unit-spec.ts` (`httpServer = null` — приложение не запускается)
  - Порты мокаются вручную через `vi.fn()`; неиспользуемые методы порта — `vi.fn()` без реализации
  - Setup: `tests/unit/setup.ts`
  - Запуск: `pnpm test:unit`
- **E2E** (`tests/e2e/`): приложение поднимается через `Root.$run()`, HTTP — через supertest.
  - База: `tests/common/common-spec.ts` (`Root` из DI-контейнера, `httpServer` для supertest)
  - Setup: `tests/e2e/setup.ts`
  - Запуск: `pnpm test:e2e` (Unimock в режиме replay); запись — `pnpm test:e2e:record`
- **Unimock** (`tests/__mocks__/e2e.ts`): запись/воспроизведение вызовов внешних сервисов. Режим задаётся через `UNIMOCK=replay` / `UNIMOCK=record`.
- **Все тесты**: `pnpm test`.
- Отчёты Allure генерируются автоматически через `allure-vitest`.
- Подробный гайд: [tests/README.md](./tests/README.md) — архитектура тестов, паттерны по слоям, Spec-иерархия.

## 📝 Запрещено

- Импортировать `@nestjs/*` в `domain/` и в прикладную логику `application/` (кроме явно оговорённых исключений в коде).
- Использовать `@InjectRepository` и прочую ORM-«магию» вне `infrastructure`.
- Создавать циклические зависимости между крупными модулями приложения.

## 🧯 Ошибки и исключения

Следуй разделу **«Ошибки и исключения (единый формат)»** в корневом [`AGENTS.md`](../../AGENTS.md) репозитория. Доменные ошибки — в `src/app/domain/error/*` на базе `BaseError` (`@biorate/errors`).
