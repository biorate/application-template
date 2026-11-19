# Tasks

## 1. Шаблоны и конфиг

- [x] 1.1 Удалить `_templates/create/root/a-before.t` и `_templates/create/root/z-after.t`
- [x] 1.2 `_templates/create/root/hooks.ts`: добавить action-метод `afterAll(ctx, results)` класса — `execSync('npx prettier --write <root>', { stdio: 'inherit' })`; при `process.platform !== 'win32'` и существовании `<root>/.husky` — `execSync('chmod ug+x <root>/.husky/*', { stdio: 'ignore' })`; root взять из `ctx.args.root`; guard на пустые results (упавшая генерация) и `ctx.dry`
- [x] 1.3 `.hygen.ts`: удалить хелпер `platform` (проверить, что в `_templates` не осталось использований)

## 2. Тесты и фикстуры

- [x] 2.1 `tests/factory.spec.ts`: снять упоминания `platform`/z-after, если есть; тест на action-хук `afterAll` (экземпляр класса root/hooks.ts)
- [x] 2.2 Регенерировать golden-фикстуры: `node tests/__fixtures__/generate-manifests.mjs` (манифесты + exec.json без prettier/chmod, с переформатированными файлами client/server)
- [x] 2.3 Прогнать `pnpm test` — все тесты зелёные

## 3. Документация

- [x] 3.1 `AGENTS.md`: убрать «a-before.t (плейсхолдер pre-checks) и z-after.t (prettier + chmod husky) исполняются первым/последним...» и пункт 2 правил (упорядочивание через имена a-before/z-after); описать `hooks.afterAll` в `.hygen.ts`
- [x] 3.2 `tests/README.md`: обновить описание exec-фикстур и убрать пункт «Порядок: z-after.t ... — последним в exec»
- [x] 3.3 Зафиксировать в документации (AGENTS.md): фабрика `helpers(locals, config)` — единственный механизм трансформации CLI-args в `h.*` (localsDefaults движка производные значения не вычисляет)

## 4. Верификация

- [x] 4.1 Контрольная генерация в `tmp/` (`root,client,server`): файлы client/server отформатированы prettier, `.husky/*` исполняемые, ошибок хука нет
- [x] 4.2 `openspec validate migrate-lifecycle-to-hooks` — без ошибок
