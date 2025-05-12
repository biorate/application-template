---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/src/enums/user.ts`) %>
unless_exists: true
---
export enum UserRoles {
  Basic = 1 << 0,
  Admin = 1 << 1,
}
