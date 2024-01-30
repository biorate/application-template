FROM node:16 as builder

WORKDIR /app

COPY . .

RUN npm i -g pnpm@8.10.2 && \
    pnpm i --frozen-lockfile --ignore-scripts && \
    pnpm run build && \
    pnpm run cleanup:node_modules && \
    pnpm i --frozen-lockfile --production --ignore-scripts && \
    pnpm store prune

FROM node:16-alpine as run

WORKDIR /app

RUN npm i -g pnpm@8.10.2 && \
    apk --no-cache add \
      curl \
      gcompat \
      openssl1.1-compat

COPY --from=builder /app .

EXPOSE 3000

CMD ["pnpm", "start"]
