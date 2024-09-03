---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/index.less`) %>
unless_exists: true
---
body,
#root {
  width: 100%;
  height: 100%;
  padding: 0;
  margin: 0;
}
