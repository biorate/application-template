# Tasks

## 1. Подготовка

- [x] 1.1 Добавить `enquirer` прямым devDep репозитория (`pnpm add -D enquirer@2.3.6`)
- [x] 1.2 Spike-проверка: экспорт `createPrompter` из `.hygen.ts` перекрывает дефолт CLI (пробная генерация с логирующим промптером)

## 2. Конфиг: TTY-гейт

- [x] 2.1 Добавить в `.hygen.ts` экспорт `createPrompter` (TTY → enquirer, non-TTY → stub `prompt: async () => ({})`), lazy `require('enquirer')` в TTY-ветке
- [x] 2.2 Синхронизировать тело `_templates/create/root/$ROOT$/.hygen.ts.t` с `.hygen.ts` (оба отформатированы repo-prettier, байт-в-байт)

## 3. Хуки: декларативная схема

- [x] 3.1 Мигрировать `_templates/create/root/hooks.ts` на `static params`: 5 required-дескрипторов (`root`, `app-name`, `app-description` — string; `cut-examples`, `add-web-socket` — boolean, `default: false`, message'ы как сейчас), метод `prompt()` удалить
- [x] 3.2 Скопировать hooks.ts в `client/` и `server/` (идентичное содержимое)
- [x] 3.3 `tsc --noEmit --strict` по всем трём hooks.ts и `.hygen.ts` чист

## 4. Тесты и фикстуры

- [x] 4.1 Обновить `tests/runner.spec.ts`: non-TTY интеграционный кейс ожидает ошибку params-валидации (`ParamRequiredError`) без зависания; актуализировать титулы
- [x] 4.2 Проверить `tests/factory.spec.ts` (sync-тест фабрик покрывает `createPrompter`; тесты валидации фабрики остаются зелёными)
- [x] 4.3 Регенерировать golden-фикстуры (`node tests/__fixtures__/generate-manifests.mjs` — хэш доставляемого `.hygen.ts` меняется)

## 5. Документация и верификация

- [x] 5.1 Обновить `AGENTS.md`: декларативная форма `static params`, `createPrompter`-гейт, прямой devDep enquirer, сноска про enquirer у целей, запускающих генератор в TTY
- [x] 5.2 `pnpm test` — все тесты зелёные
- [x] 5.3 Diff-матрица: 16 комбинаций против эталонов HEAD, единственная дельта — содержимое доставляемого `.hygen.ts` (createPrompter), побайтово
- [x] 5.4 Ручная TTY-проверка: 4 вопроса (2 input + 2 confirm с initial false), переданные флаги не переспрашиваются
- [x] 5.5 CI-симуляция: запуск без флагов в non-TTY завершается `ParamRequiredError` быстро (без hang)
- [x] 5.6 `openspec validate migrate-hooks-to-params-schema --strict` — valid
