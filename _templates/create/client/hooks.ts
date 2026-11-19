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
}
