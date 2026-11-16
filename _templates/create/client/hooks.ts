/**
 * Action hooks действия `create` (классовая форма @biorate/hygen >= 0.5.1).
 * Параметры объявлены декларативно: params-фаза движка приводит флаги к
 * объявленным типам, запрашивает в TTY недостающие required-параметры и
 * валидирует результат. Все параметры required: в non-TTY (CI) контракт —
 * передавать флаги явно, нарушение даёт чистую ошибку ParamRequiredError
 * (stub-промптер конфига не отвечает, enquirer не вызывается).
 */
class Hooks {
  static params = [
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
}

export default Hooks;
