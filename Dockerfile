FROM node:16 as builder

WORKDIR /app

COPY . .

RUN npm i -g pnpm@8.10.2 && \
    pnpm i --frozen-lockfile && \
    pnpm run build && \
    pnpm run cleanup:node_modules && \
    pnpm i --frozen-lockfile --production

FROM node:16-alpine as run

WORKDIR /app

RUN npm i -g pnpm@8.10.2 && \
    apk --no-cache add curl gcompat openssl1.1-compat && \
    addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nodejs

COPY --from=builder --chown=nodejs:nodejs /app .

EXPOSE 3000

CMD ["pnpm", "start"]
