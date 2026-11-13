---
to: <%= `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/infrastructure/http/out/request/dto/info.ts` %>
unless_exists: true
---
export type GETInfoREQ = unknown;

export type GETInfoRES = {
  ENV: string;

  version: string;

  name: string;
};
