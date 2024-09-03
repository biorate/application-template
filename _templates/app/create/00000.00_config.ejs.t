---
---
<%
  ROOT = locals['root'] ?? cwd;
  SERVICE_NAME = locals['service-name'];
  SERVICE_DESCRIPTION = locals['service-description'];
  SERVER = locals['server'];
  CLIENT = locals['client'];
  HYGEN = locals['hygen'];
  SERVER_NAME = SERVICE_NAME + '-server';
  CLIENT_NAME = SERVICE_NAME + '-client';
  SERVER_DIR = `${ROOT}/apps/${SERVER_NAME}`;
  CLIENT_DIR = `${ROOT}/apps/${CLIENT_NAME}`;
  CUT_EXAMPLES = locals['cut-examples'];
  ADD_WEB_SOCKET = locals['add-web-socket'];

  h.defined({
    SERVICE_NAME,
    SERVICE_DESCRIPTION,
  });
%>
