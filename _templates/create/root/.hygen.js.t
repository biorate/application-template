const fs = require('fs');
const path = require('path');
const minimist = require('minimist');
const _ = require('lodash');
const { platform } = require('os');

const argv = minimist(process.argv);

module.exports = {
  helpers: (locals, config) => {
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
      (key) => locals[key] === undefined || locals[key] === '',
    );
    if (missing.length) {
      throw new Error(`[--${missing.map(_.kebabCase).join('], [--')}] is not defined`);
    }

    // Guard: запрещаем рендер точно в корень репозитория шаблона
    const templatesRoot = path.resolve(path.dirname(config.templates));
    let realRoot = null;
    let realTemplates = null;
    try {
      realRoot = fs.realpathSync.native(path.resolve(locals.root));
      realTemplates = fs.realpathSync.native(templatesRoot);
    } catch (error) {
      // каталога ещё нет / недоступен — guard неприменим
    }
    if (realRoot && realTemplates && realRoot === realTemplates) {
      throw new Error(
        `[--root] ${locals.root} is the template repository itself: generation into the template repository is forbidden`,
      );
    }

    return {
      _,
      platform: platform(),
      stringify: (data) => JSON.stringify(data),
      root: (p) => p,
      defined: (args) => {
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
  },
};
