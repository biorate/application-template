---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/src/api/google.ts`) %>
unless_exists: true
---
import { AxiosPrometheus } from '@biorate/axios-prometheus';

export class GETGoogle extends AxiosPrometheus {
  public baseURL = 'https://google.com';

  public url = '/';

  public method = 'get';

  public static fetch() {
    return this._fetch<string>();
  }
}
