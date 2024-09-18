---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/consts.tsx`) %>
unless_exists: true
---
export class COMMON {
  public static HEADER_HEIGHT = 64;

  public static FOOTER_HEIGHT = 64;
}

export class SLOTS {
  public static HEADER = 'header';

  public static CONTENT = 'content';

  public static FOOTER = 'footer';
}
