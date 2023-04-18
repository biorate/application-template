import { injectable, init, inject, Types } from '@biorate/inversion';
import { IConfig } from '@biorate/config';
import { timer } from '@biorate/tools';

@injectable()
export class Websocket {
  @inject(Types.Config) protected config: IConfig;

  protected socket: WebSocket;

  protected ready = false;

  protected onOpen = (...args: any) => {
    this.ready = true;
  };

  protected onClose = async () => {
    this.ready = false;
    await timer.wait(this.config.get('WebSocket.reconnect_timeout', 1000));
    await this.connect();
  };

  protected onError = (e: Event) => {
    console.error(e);
  };

  protected onMessage = (data: MessageEvent) => {
    console.log(data);
  };

  protected async connect() {
    if (this.socket) {
      this.socket.onopen = null;
      this.socket.onclose = null;
      this.socket.onerror = null;
      this.socket.onmessage = null;
    }
    this.socket = new WebSocket(
      this.config.get<string>(
        'WebSocket.url',
        `ws://${this.config.get('location.host')}`,
      ),
    );
    this.socket.onopen = this.onOpen;
    this.socket.onclose = this.onClose;
    this.socket.onerror = this.onError;
    this.socket.onmessage = this.onMessage;
    while (!this.ready) await timer.wait();
  }

  @init() protected async initialize() {
    this.connect();
  }

  public send(data: unknown) {
    this.socket.send(JSON.stringify(data));
  }
}
