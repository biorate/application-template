---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/components/spinner/index.module.less`) %>
unless_exists: true
---
.spinner {
  position: fixed;
  z-index: 9990;
  top: 0;
  left: 0;
  display: flex;
  width: 100vw;
  height: 100vh;
  align-items: center;
  justify-content: center;
  background: rgb(255 255 255 / 25%);

  &__spin {
    z-index: 9991;
  }

  .ant-spin-dot-item {
    background-color: var(--primary-color);
  }
}
