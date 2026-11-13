module.exports.prompt = async ({ prompter, args }) => {
  const missing = (key) =>
    args[key] === undefined || args[key] === null || args[key].length === 0;
  // Не-интерактивный режим (CI/скрипты): без вопросов — валидацию выполнит фабрика хелперов
  if (!process.stdin.isTTY) return {};
  return prompter.prompt(
    [
      missing('app-name') && { type: 'input', name: 'app-name', message: 'App name:' },
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
    ].filter(Boolean),
  );
};
