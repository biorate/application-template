---
message: |
  Использование: npx hygen create <actions> --root=<dir> --app-name=<name> --app-description=<desc>

  <actions> - список действий через запятую, определяет состав генерации:
    root   - корень монорепозитория (конфиги, CI-файлы, README, AGENTS.md, .hygen.js)
    client - клиентское приложение (React + MobX) в apps/<app-name>-client
    server - серверное приложение (NestJS) в apps/<app-name>-server
    Пример: npx hygen create root,client,server --root=tmp/my-app ...

  --root - обязательный путь генерации (не может совпадать с корнем репозитория шаблона)
  --app-name - имя продукта (Пример - my-new-shiny-app)
  --app-description - краткое описание продукта
  --cut-examples - убрать примеры из сгенерированного кода
  --add-web-socket - добавить WebSocket (Nest gateways + события в шаблоне)
---
