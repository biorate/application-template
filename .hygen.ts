import fs from 'fs';
import path from 'path';
import _ from 'lodash';
import { HygenConfig, RunnerContextConfig } from '@biorate/hygen';

export default class Config extends HygenConfig {
  public helpers = (locals: Record<string, unknown>, config: RunnerContextConfig) => {
    if (locals.action === 'help') return { _ };

    // Обязательные параметры: валидация до резолва путей
    const missing = ['root', 'app-name', 'app-description'].filter(
      (key) => locals[key] === undefined || locals[key] === '',
    );
    if (missing.length) {
      throw new Error(`[--${missing.map(_.kebabCase).join('], [--')}] is not defined`);
    }

    const templatesRoot = fs.realpathSync.native(
      path.resolve(path.dirname(config.templates)),
    );
    let rootPath = path.resolve(<string>locals.root);
    if (fs.existsSync(rootPath)) rootPath = fs.realpathSync.native(rootPath);
    if (rootPath === templatesRoot) {
      throw new Error(
        `[--root] ${locals.root} is the template repository itself: generation into the template repository is forbidden`,
      );
    }
    return {
      _,
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
      CLIENT: locals._[1]?.includes?.('client'),
      SERVER: locals._[1]?.includes?.('server'),
      CUT_EXAMPLES: locals['cut-examples'],
      ADD_WEB_SOCKET: locals['add-web-socket'],
    };
  };
}
