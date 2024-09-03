---
to: <%= h.root(`${ROOT}/.npmrc`) %>
unless_exists: true
---
@payment:registry=https://art.lmru.tech/api/npm/npm-payment/
registry=https://art.lmru.tech/api/npm/npm-microfronts/
engine-strict=true
