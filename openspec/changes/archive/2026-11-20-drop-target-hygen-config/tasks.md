# Tasks

## 1. Шаблоны

- [x] 1.1 Удалить `_templates/create/root/$ROOT$/.hygen.ts.t` (dep `@biorate/hygen` в `package.json.t` цели сохраняется — догенерация шаблонов)

## 2. Тесты и фикстуры

- [x] 2.1 Удалить sync-тест `root and repo .hygen.ts.t stay in sync` из `tests/factory.spec.ts` (и иные упоминания доставленного файла в тестах, если найдутся)
- [x] 2.2 Регенерировать golden-фикстуры: `node tests/__fixtures__/generate-manifests.mjs`
- [x] 2.3 Прогнать `pnpm test` — все тесты зелёные, diff-матрица пуста

## 3. Документация

- [x] 3.1 `AGENTS.md`: убрать строки о доставке фабрики (строки 69, 86, 120 — про `.hygen.ts.t`, байт-синхронизацию и «та же фабрика кладётся в сгенерированный репозиторий»)
- [x] 3.2 Греп-проход: `hygen.ts.t`, `unless_exists`, `@biorate/hygen` в `doc/`, `README.md`, `tests/README.md` — снять устаревшие упоминания

## 4. Верификация

- [x] 4.1 Контрольная генерация в `tmp/` без `--cut-examples`: убедиться, что `.hygen.ts` в цели отсутствует, dep `@biorate/hygen` в корневом `package.json` сохранён, остальные файлы на месте
- [x] 4.2 `openspec validate drop-target-hygen-config` — без ошибок
