---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/components/hello/index.less`) %>
unless_exists: true
---
.button {
  margin-right: 5px;
  border-radius: 5px;
  height: 30px;
  width: 100px;
}
