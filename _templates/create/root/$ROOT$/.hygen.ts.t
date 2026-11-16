---
unless_exists: true
mirror: true
---
import fs from 'fs';
import path from 'path';
import _ from 'lodash';
import { platform } from 'os';
import { createRequire } from 'module';

/**
 * TTY-aware фабрика промптеров: перекрывает дефолт CLI (резолвер спредит
 * конфиг поверх него) и применяется движком ко всем фазам промпта, включая
 * params-фазу. В TTY возвращается класс enquirer (как дефолт CLI; промпт —
 * статический метод), в non-TTY — stub без ответов: params-фаза завершается
 * валидационной ошибкой, не зависая на enquirer, который в non-TTY не
 * резолвится. enquirer требуется лениво и только в TTY-ветке.
 */
const nodeRequire = createRequire(path.join(process.cwd(), 'package.json'));

export const createPrompter = () =>
  process.stdin.isTTY && process.stdout.isTTY
    ? nodeRequire('enquirer')
    : { prompt: async () => ({}) };

/**
 * Фабрика хелперов генератора (классовая конфигурация @biorate/hygen).
 * Вызывается движком на реальный рендер с разобранными locals; справочное
 * действие `help` и бутстрап без argv обслуживаются минимальным набором.
 */
export const helpers = (locals: Record<string, any>, config: { templates: string }) => {
  // Справочное действие не требует параметров генерации
  if (locals.action === 'help') {
    return { _ };
  }

  // Состав генерации определяется списком действий (2-й позиционный аргумент)
  const actions = String((locals._ && locals._[1]) || '')
    .split(',')
    .filter(Boolean);

  // Обязательные параметры
  const missing = ['root', 'app-name', 'app-description'].filter(
    (key: string) => locals[key] === undefined || locals[key] === '',
  );
  if (missing.length) {
    throw new Error(`[--${missing.map(_.kebabCase).join('], [--')}] is not defined`);
  }

  // Guard: запрещаем рендер точно в корень репозитория шаблона.
  // Несуществующий --root разрешён (директория создаётся генерацией позже):
  // несуществующий путь сверяется со строкой, существующий — через realpath
  // (symlink на корень репозитория тоже ловится).
  const templatesRoot = fs.realpathSync.native(
    path.resolve(path.dirname(config.templates)),
  );
  let rootPath = path.resolve(locals.root);
  if (fs.existsSync(rootPath)) rootPath = fs.realpathSync.native(rootPath);
  if (rootPath === templatesRoot) {
    throw new Error(
      `[--root] ${locals.root} is the template repository itself: generation into the template repository is forbidden`,
    );
  }

  return {
    _,
    platform: platform(),
    stringify: (data: unknown) => JSON.stringify(data),
    defined: (args: Record<string, unknown>) => {
      for (const field in args) {
        if (typeof args[field] === 'undefined') {
          throw new Error(`[--${_.kebabCase(field)}] is not defined`);
        }
      }
    },
    ROOT: locals.root,
    APP_NAME: locals['app-name'],
    APP_DESCRIPTION: locals['app-description'],
    SERVER_NAME: `${locals['app-name']}-server`,
    CLIENT_NAME: `${locals['app-name']}-client`,
    CLIENT: actions.includes('client'),
    SERVER: actions.includes('server'),
    CUT_EXAMPLES: locals['cut-examples'],
    ADD_WEB_SOCKET: locals['add-web-socket'],
  };
};
