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
  PRODUCT_ID = locals['product-id'];
  PRODUCT = locals['product'];
  CHANNEL_IDS =  locals['channel-ids'];
  NAMESPACE_PREFIX = locals['namespace-prefix'];
  SERVICE_ACCOUNT = locals['service-account'];
  COMMON_CHART_VERSION = locals['common-chart-version'] ?? '0.3.5';
  STAGE_CLUSTERS = locals['stage-clusters'];
  PROD_CLUSTERS = locals['prod-clusters'];
  NAMESPACE = locals['namespace'];
  APPROLE_CREDENTIALS_ID = locals['approle-credentials-id'];
  PROJECT_NAME = locals['project-name'];
  CREDENTIALS_ID = locals['credentials-id'];
  MAIN_BRANCH = locals['main-branch'] ?? 'develop';
  CUT_EXAMPLES = locals['cut-examples'];
  ADD_WEB_SOCKET = locals['add-web-socket'];

  h.defined({
    SERVICE_NAME,
    SERVICE_DESCRIPTION,
    PRODUCT_ID,
    PRODUCT,
    CHANNEL_IDS,
    NAMESPACE_PREFIX,
    SERVICE_ACCOUNT,
    STAGE_CLUSTERS,
    PROD_CLUSTERS,
    NAMESPACE,
    APPROLE_CREDENTIALS_ID,
    PROJECT_NAME,
    CREDENTIALS_ID,
  });
%>
