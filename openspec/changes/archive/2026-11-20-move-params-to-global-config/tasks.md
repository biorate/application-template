# Tasks

## 1. Хуки действий

- [x] 1.1 `_templates/create/root/hooks.ts`: `static params` → instance `params`
- [x] 1.2 `_templates/create/client/hooks.ts`: `static params` → instance `params`
- [x] 1.3 `_templates/create/server/hooks.ts`: `static params` → instance `params`

## 2. Фабрика

- [x] 2.1 `.hygen.ts`: глобальный член `params` удалён (эксперимент change откачен — ломал `hygen create help`)

## 3. Тесты

- [x] 3.1 `tests/factory.spec.ts`: тест instance-`params` трёх хуков + тест отсутствия `params` в конфиге фабрики

## 4. Верификация

- [x] 4.1 `pnpm test` — 22/22 зелёные, diff-матрица пуста
- [x] 4.2 `npx hygen create help` — параметры не запрашиваются (non-TTY проверка)
