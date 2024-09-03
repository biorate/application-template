---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/types/IError.ts`) %>
unless_exists: true
---
export type IError<H = unknown> = Error & {
  response?: { data?: { code?: string; hint?: H } };
};
