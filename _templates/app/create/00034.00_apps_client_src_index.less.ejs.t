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

.center {
  width: 100vw;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}
