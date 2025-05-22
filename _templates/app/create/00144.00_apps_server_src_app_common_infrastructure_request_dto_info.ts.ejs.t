---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/infrastructure/request/dto/info.ts`) %>
unless_exists: true
---
export type GETInfoREQ = unknown;

export type GETInfoRES = {
  ENV: string;

  version: string;

  name: string;
};
