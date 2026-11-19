import fs from 'fs';
import path from 'path';
import { execSync } from 'child_process';

export default class Hooks {
  public static params = [
    { name: 'root', type: 'string', required: true, message: 'Root path:' },
    { name: 'app-name', type: 'string', required: true, message: 'App name:' },
    {
      name: 'app-description',
      type: 'string',
      required: true,
      message: 'App description:',
    },
    {
      name: 'cut-examples',
      type: 'boolean',
      required: true,
      default: false,
      message: 'Cut examples?',
    },
    {
      name: 'add-web-socket',
      type: 'boolean',
      required: true,
      default: false,
      message: 'Add WebSocket?',
    },
  ];

  public async afterAll(
    ctx: {
      args: { root?: string; ROOT?: string };
      dry: boolean;
      logger: { warn: (msg: string) => void };
    },
    results: Array<Record<string, unknown>>,
  ) {
    if (ctx.dry || !results?.length) return;
    const root = ctx.args.ROOT;
    if (!root)
      return void ctx.logger.warn(
        'afterAll: --root is not defined, post-processing skipped',
      );
    execSync(`npx prettier --write ${root}`, { stdio: 'inherit' });
    if (process.platform !== 'win32' && fs.existsSync(path.join(root, '.husky'))) {
      execSync(`chmod ug+x ${root}/.husky/*`, { stdio: 'ignore' });
    }
  }
}
