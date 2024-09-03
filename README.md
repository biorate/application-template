# Fullstack typescript шаблон приложения (Nestjs + React + Inversify.JS)

## Пример создания приложения:

- `pnpm i`
- `npx hygen app help`
- `npx hygen app create --client --server --hygen --product-id=PXXXX --product=pof --channel-ids=9fti5gw46jfw5e8i8rbbp8sjhc --namespace-prefix=payment-pof --service-account=lm-sa-payment --stage-clusters=sirius-a-stage --prod-clusters=payment,sirius-a --namespace=payment --approle-credentials-id=approle-repository-factory --project-name=payment --service-name=name-of-the-app --service-description='My app name' --credentials-id=ghe-svc-lmru-payment-jenkins-integration --add-web-socket`

## Запуск приложения:

- `pnpm i`
- `pnpm run build:debug` - запуск клиента в режиме разработки
- `pnpm run start:debug` - запуск сервера в режиме разработки

## Правила создания коммитов:

Мы используем [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) для
формирования автоматического CHANGELOG-а и версионирования приложений.

Используйте `fix:` префикс для изменения patch-составляющей версии.

Используйте `feat:` префикс для изменения minor-составляющей версии.

Используйте `BREAKING CHANGE:` в футере для изменения major-составляющей версии.

### Подробности по ссылке [Conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).

## Правила именования:

- Используйте kebab-case для именования папок и файлов
- Используйте camelCase для именования переменных и функций
- Используйте PascalCase для именования классов

## Документация:

- [Архитектура](./doc/ARCHITECTURE.md)
- [Конфигурирование](./doc/CONFIGURATION.md)
  - [Конфигурирование переменными окружения](./doc/ENV_LOADER.md)
  - [Конфигурирование фалами](./doc/FILE_LOADER.md)
  - [Конфигурирование с помощью VAULT](./doc/VAULT_LOADER.md)
  - [Запуск приложения на другом порту](./doc/APP_STARTUP_CONFIG.md)
- [Коннекторы](./doc/CONNECTORS.md)
  - [Minio](./doc/MINIO.md)
