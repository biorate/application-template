import { realpathSync, existsSync } from 'fs';
import path from 'path';
import _ from 'lodash';
import { HygenConfig, RunnerContextConfig } from '@biorate/hygen';

export default class Config extends HygenConfig {
  public argCase: 'keep' | 'upper-underscore' = 'upper-underscore';

  public helpers = (locals: Record<string, unknown>, config: RunnerContextConfig) => {
    if (locals.action === 'help') return { _ };
    this.guard(locals, config);
    return {
      _,
      ...locals,
      SERVER_NAME: `${locals.APP_NAME}-server`,
      CLIENT_NAME: `${locals.APP_NAME}-client`,
      CLIENT: locals._[1]?.includes?.('client'),
      SERVER: locals._[1]?.includes?.('server'),
    };
  };

  protected guard(locals: Record<string, unknown>, config: RunnerContextConfig) {
    const root = <string>locals.root;
    const templatesRoot = realpathSync.native(
      path.resolve(path.dirname(config.templates)),
    );
    let rootPath = path.resolve(root);
    if (existsSync(rootPath)) rootPath = realpathSync.native(rootPath);
    if (rootPath === templatesRoot) {
      throw new Error(
        `[--root] ${root} is the template repository itself: generation into the template repository is forbidden`,
      );
    }
  }
}
