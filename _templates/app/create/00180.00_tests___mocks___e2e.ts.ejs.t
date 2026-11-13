---
to: <%= h.server(`${ROOT}/apps/${SERVER_NAME}/tests/__mocks__/e2e.ts`) %>
unless_exists: true
---
/**
 * Unimock — запись/воспроизведение вызовов методов класса.
 *
 * Для включения режима записи:
 *   UNIMOCK=record UNIMOCK_STRIP_REQUEST=1 UNIMOCK_GZIP=1 pnpm test:e2e
 *
 * Для воспроизведения (по умолчанию, CI):
 *   UNIMOCK=replay pnpm test:e2e
 *
 * Чтобы замокать конкретный коннектор:
 *   1. Импортируйте класс и оберните @Mockable()
 *   2. Перебиндьте его в container через container.unbind/bind
 *   3. Запросы сохранятся в tests/e2e/__snapshots__/
 *
 * Пример использования Unimock для мокирования внешних коннекторов.
 * @Mockable() автоматически перехватывает все вызовы методов класса и сохраняет/воспроизводит их.
 * Все запросы сохраняются в tests/e2e/__snapshots__/.
 *
 *   import { container, Types } from '@biorate/inversion';
 *   import { Mockable, noop } from '@biorate/unimock';
 *   import { ClickhouseConnector as BaseClickhouseConnector } from '@biorate/clickhouse';
 *
 *   @Mockable()
 *   class ClickhouseConnector extends BaseClickhouseConnector {}
 *
 *   container.rebind(Types.Prometheus).toConstantValue(noop); // Мокирование всех методов на пустышки
 *   container.unbind(Types.Clickhouse);
 *
 *   container.bind(Types.Clickhouse).to(ClickhouseConnector).inSingletonScope();
 */
