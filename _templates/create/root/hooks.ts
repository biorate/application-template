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
    try {
      execSync(`npx prettier --write ${root}`, { stdio: 'inherit' });
      if (process.platform !== 'win32')
        execSync(`chmod ug+x ${root}/.husky/*`, { stdio: 'ignore' });
    } catch (e) {
      ctx.logger.warn(`afterAll: ${e?.message ?? e?.toString?.() ?? String(e)}`);
    }
  }
}
