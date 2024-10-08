---
to: <%= h.client(`${ROOT}/.stylelintrc.json`) %>
unless_exists: true
---
{
  "extends": ["stylelint-config-standard", "stylelint-config-idiomatic-order"],
  "overrides": [
    {
      "files": ["**/*.scss"],
      "customSyntax": "postcss-scss"
    },
    {
      "files": ["**/*.less"],
      "customSyntax": "postcss-less"
    },
    {
      "files": ["**/*.tsx"],
      "customSyntax": "postcss-styled-syntax"
    }
  ],
  "plugins": ["stylelint-csstree-validator", "stylelint-order"],
  "rules": {
    "csstree/validator": {
      "syntaxExtensions": ["sass", "less"]
    },
    "order/order": ["custom-properties", "declarations"]
  }
}
