# Tasks

## 1. Подготовка

- [x] 1.1 Зафиксировать эталонные генерации всех комбинаций (действия: `root`, `root,client`, `root,server`, `root,client,server`; флаги: `--add-web-socket`, `--cut-examples`) из HEAD в tmp/; проверка: 8 эталонных каталогов созданы
- [x] 1.2 Базовый прогон `pnpm test` — зелёный; проверка: 20/20

## 2. Классовые hooks.ts (3 действия)

- [x] 2.1 Создать `_templates/create/{root,client,server}/hooks.ts` — класс с дефолт-экспортом, async-метод `prompt({ prompter, args })` с текущей логикой (non-TTY → `{}`, TTY → только недостающие `app-name`, `app-description`, `cut-examples`, `add-web-socket`); самодостаточные минимальные интерфейсы (типы ActionHooks/Prompter не ре-экспортируются `@biorate/hygen`); удалить три `prompt.js`; проверка: `find _templates -name "prompt.js"` пуст, `find _templates -name "hooks.ts"` = 3
- [x] 2.2 Генерация в tmp/ без флагов в non-TTY и в TTY-эмуляции; проверка: non-TTY — валидационная ошибка фабрики, TTY — запрашиваются только недостающие параметры, ответы применяются
- [x] 2.3 Обновить `tests/runner.spec.ts` (3 теста на `prompt.js`) под `hooks.ts`; проверка: `pnpm test tests/runner.spec.ts` зелёный

## 3. Фабрика .hygen.ts

- [x] 3.1 Удалить `.hygen.js` (git rm); создать `.hygen.ts` — TS-фабрика с **именованным экспортом** `export const helpers = (locals, config) => {...}` (`export default` ломает движок — резолвер спредит namespace модуля, ошибка была `createPrompter is not a function`)
- [x] 3.2 Добавить ts-node@^10.9.2 в devDeps, даунгрейд typescript `^7.0.2` → `^5.0.4` (ts-node@10.9.2 несовместим с TS7: `TypeError: ... (reading 'fileExists')` на ts.sys); в шаблоне цели (`package.json.t`) версии уже были
- [x] 3.3 Фикс guard'а фабрики: несуществующий `--root` разрешён — ресолв к ближайшему существующему предку пути перед `realpathSync` (раньше падал realpath ENOENT; старые тесты маскировали это грязным /tmp)
- [x] 3.4 Обновить `tests/factory.spec.ts` (suite «Factory (.hygen.ts helpers)», `loadFactory` через `ts-node/register/transpile-only` + `nodeRequire('.hygen.ts')`, root в тестах = `os.tmpdir()`) и `tests/common/generator-spec.ts` (loadFactory); проверка: `pnpm test tests/factory.spec.ts` зелёный

## 4. Доставка фабрики в цели

- [x] 4.1 Создать `_templates/create/root/$ROOT$/.hygen.ts.t` с frontmatter `mirror: true`, `unless_exists: true`, тело байт-в-байт синхронно с `.hygen.ts`; проверка: генерация `root,...` создаёт `<root>/.hygen.ts`, содержимое синхронно с фабрикой репозитория
- [x] 4.2 Повторная генерация в существующую цель; проверка: `.hygen.ts` цели не перезаписан (`unless_exists`), остальные файлы по политике `unless_exists`

## 5. Фикстуры, документация, верификация

- [x] 5.1 Регенерировать фикстуры (`node tests/__fixtures__/generate-manifests.mjs`); проверка: манифесты действий с `root` содержат хэш `.hygen.ts`, остальные не изменились кроме нового файла
- [x] 5.2 Обновить `AGENTS.md`: упоминание `prompt.js` → `hooks.ts` (классовая форма), правило доставки фабрики `.hygen.ts` в цель, окружение ts-node/typescript@5.0.4; проверка: `grep -rn "prompt.js\|hygen.js" AGENTS.md` пуст
- [x] 5.3 Полный прогон: `pnpm install && pnpm test`; проверка: 0 падений
- [x] 5.4 Сверка с эталонами из 1.1 для всех 8 комбинаций (побайтово, 16/16); проверка: diff пуст везде, кроме добавленного `.hygen.ts` в действиях с `root`
- [x] 5.5 Prettier-синхронизация: `.hygen.ts` и `hooks.ts` отформатированы repo-prettier, чтобы доставленная копия была байт-в-байт идентична (prettier в `z-after.t` переформатирует цель)
