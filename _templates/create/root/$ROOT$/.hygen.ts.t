---
unless_exists: true
mirror: true
---
import fs from 'fs';
import path from 'path';
import _ from 'lodash';
import { platform } from 'os';

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
  // ресолвим ближайшего существующего предка пути.
  const templatesRoot = path.resolve(path.dirname(config.templates));
  let existing = path.resolve(locals.root);
  while (!fs.existsSync(existing)) existing = path.dirname(existing);
  const realRoot = fs.realpathSync.native(existing);
  if (templatesRoot === realRoot) {
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
