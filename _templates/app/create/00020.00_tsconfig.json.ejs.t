---
to: <%= h.root(`${ROOT}/tsconfig.json`) %>
unless_exists: true
---
{
  "compilerOptions": {
    "lib": [
      "ES2015",
      "ES2016",
      "ES2017",
      "ES2018",
      "ES2019",
      "ES2020",
      "ES2020.Promise",
      "ESNext"
      <%- CLIENT ? ',"dom"' : '' %>
    ],
    "skipLibCheck": true,
    "module": "commonjs",
    "declaration": false,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "resolveJsonModule": true,
    "target": "es2017",
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": "./",
    "incremental": true,
    <%- CLIENT ? '"jsx": "react",' : '' -%>
    "paths": {}
  },
  "ts-node": {
    "transpileOnly": true
  }
}
