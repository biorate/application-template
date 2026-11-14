# Tasks

## 1. Подготовка

- [x] 1.1 Зафиксировать текущий инвентарь фронтматтера (список файлов с `to:`, категорий условных) для сверки по завершении; проверка: файл-инвентарь (в tmp/, не в репо) совпадает с `grep -rn "to:" _templates --include="*.t" | wc -l` = 180
- [x] 1.2 Прогнать базовый тест (`pnpm test`) на 0.2.0 до изменений — зелёный; проверка: все спеки проходят

## 2. Действие root (~20 шаблонов)

- [x] 2.1 Вложить root-шаблоны в `_templates/create/root/$ROOT$/` (git mv), удалить строку `to:`, добавить `mirror: true`; проверка: `grep -rn "to:" _templates/create/root --include="*.t"` пуст, `a-before.t`/`z-after.t` (вне `$ROOT$`) остались в корне действия
- [x] 2.2 Условные root-шаблоны (`.stylelintrc.json.t` и иные с `h.CLIENT &&`/`h.SERVER &&`) — добавить `skip: <%= !h.CLIENT && 'client action not requested' %>` (аналогично для server); проверка: генерация `root` без `client` в tmp/ — файл отсутствует, в логе `skipped`, без ошибок
- [x] 2.3 Условные по `CUT_EXAMPLES`/`ADD_WEB_SOCKET` в root — `skip: <%= h.CUT_EXAMPLES && 'examples cut' %>` и `skip: <%= !h.ADD_WEB_SOCKET && 'web socket not requested' %>`; проверка: генерация `root,client` c `--cut-examples --add-web-socket` и без — состав файлов идентичен фикстурам
- [x] 2.4 Регенерировать фикстуры (`node tests/__fixtures__/generate-manifests.mjs`), прогнать `pnpm test`; проверка: diff-матрица по действию `root` пуста

## 3. Действие client (~80 шаблонов)

- [x] 3.1 Переименовать `client/apps/client/` → `client/apps/$CLIENT_NAME$/` (git mv); проверка: дерево переименовано, `git status` показывает только rename
- [x] 3.2 Массово убрать `to:` из всех client-шаблонов, добавить `mirror: true`; условные — `skip:` по схеме из группы 2; проверка: `grep -rn "to:" _templates/create/client --include="*.t"` пуст
- [x] 3.3 Тестовая генерация в tmp/: `root,client` и `client` отдельно, с флагами и без; проверка: состав файлов совпадает с предыдущей генерацией, имена папок подставлены (`<app>-client`)
- [x] 3.4 Регенерировать фикстуры, прогнать `pnpm test`; проверка: diff-матрица по `client` пуста

## 4. Действие server (~80 шаблонов)

- [x] 4.1 Переименовать `server/apps/server/` → `server/apps/$SERVER_NAME$/` (git mv)
- [x] 4.2 Убрать `to:`, добавить `mirror: true`; условные (`CUT_EXAMPLES`, примеры тестов) — `skip:`; проверка: `grep -rn "to:" _templates/create/server --include="*.t"` пуст
- [x] 4.3 Тестовая генерация в tmp/: `root,server` и `root,client,server` с `--add-web-socket`/без; проверка: состав файлов идентичен прежнему
- [x] 4.4 Регенерировать фикстуры, прогнать `pnpm test`; проверка: diff-матрица по `server` пуста

## 5. Фабрика и документация

- [x] 5.1 Удалить `h.root` из `.hygen.js` и синхронно из `_templates/create/root/.hygen.js.t`; совместимость с `@biorate/hygen`: временный bootstrap-хак (0.3.0) удалён после выхода 0.4.0 с ленивым резолвом hook helpers — фабрика не требует защитного кода; проверка: `grep -rn "h.root" .hygen.js _templates` пуст, `grep -c "locals._ === undefined"` = 0, тесты зелёные
- [x] 5.2 Обновить `AGENTS.md` (раздел про шаблоны, пункт 3: правило `to:` → правила mirror/path macros/`skip:`) и синхронно `_templates/create/root/AGENTS.md.t`; проверить `README.md` и `doc/` на упоминания `to:`/`h.root`; проверка: `grep -rn "to:" AGENTS.md README.md doc/` не содержит устаревших правил
- [x] 5.3 Просмотреть `tests/factory.spec.ts` и `tests/runner.spec.ts` на ассерты, привязанные к `to:`/пути; обновить при необходимости; проверка: `pnpm test` полностью зелёный

## 6. Итоговая верификация

- [x] 6.1 Полный прогон: `pnpm install && pnpm test`; проверка: 0 падений, фикстуры актуальны
- [x] 6.2 E2E полного приложения в tmp/: `npx hygen create root,client,server --root=tmp/demo --app-name=demo --app-description='Demo' --add-web-socket`, затем вариант с `--cut-examples`; проверка: структура и содержимое побайтово совпадают с до-миграционной эталонной генерацией
- [x] 6.3 Сверка с инвентарём из 1.1: `grep -rn "to:" _templates --include="*.t"` — только шаблоны, явно оставленные с `to:` (ожидается 0); все 33 условных переведены на `skip:`; проверка: `grep -rn "skip:" _templates --include="*.t" | wc -l` = 33
