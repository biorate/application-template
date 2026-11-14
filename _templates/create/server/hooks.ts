/**
 * Action hooks действия `create` (классовая форма @biorate/hygen >= 0.4.0).
 * Секция prompt запрашивает только параметры, отсутствующие в CLI-аргументах;
 * в не-интерактивном режиме (CI/скрипты) вопросов нет — валидацию выполняет
 * фабрика хелперов .hygen.ts.
 */
interface PromptArgs {
  type: string;
  name: string;
  message: string;
}

interface PromptInput {
  prompter: { prompt: (questions: PromptArgs[]) => Promise<Record<string, unknown>> };
  args: Record<string, unknown>;
}

export default class Hooks {
  async prompt({ prompter, args }: PromptInput) {
    const missing = (key: string) => {
      const value = args[key];
      return (
        value === undefined ||
        value === null ||
        (Array.isArray(value) && value.length === 0) ||
        value === ''
      );
    };
    if (!process.stdin.isTTY) return {};
    return prompter.prompt(
      (
        [
          missing('app-name') && {
            type: 'input',
            name: 'app-name',
            message: 'App name:',
          },
          missing('app-description') && {
            type: 'input',
            name: 'app-description',
            message: 'App description:',
          },
          missing('cut-examples') && {
            type: 'confirm',
            name: 'cut-examples',
            message: 'Cut examples?',
          },
          missing('add-web-socket') && {
            type: 'confirm',
            name: 'add-web-socket',
            message: 'Add WebSocket?',
          },
        ] as (PromptArgs | false | null)[]
      ).filter(Boolean) as PromptArgs[],
    );
  }
}
