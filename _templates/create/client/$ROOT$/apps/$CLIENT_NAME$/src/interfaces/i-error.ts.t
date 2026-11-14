---
unless_exists: true
mirror: true
---
export type IError<H = unknown> = Error & {
  response?: { data?: { code?: string; hint?: H } };
};
