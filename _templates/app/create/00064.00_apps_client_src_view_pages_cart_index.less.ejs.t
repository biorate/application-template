---
to: <%= h.client(`${ROOT}/apps/${CLIENT_NAME}/src/view/pages/cart/index.less`) %>
unless_exists: true
---
.cart {
  display: block;
}
