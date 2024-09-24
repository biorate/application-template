---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/types/i-error.ts`) %>
unless_exists: true
---
export type IError<H = unknown> = Error & {
  response?: { data?: { code?: string; hint?: H } };
};
