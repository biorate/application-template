---
to: <%= h.root(`${ROOT}/Dockerfile`) %>
unless_exists: true
---
FROM docker-remote-docker-io.art.lmru.tech/node:20.17.0 as builder
ARG APP
ENV APP=$APP
WORKDIR /app
COPY . .
RUN npm i -g --registry=https://art.lmru.tech/artifactory/api/npm/npm pnpm@9.7.1 && \
    pnpm i --frozen-lockfile && \
    pnpm run build && \
    pnpm run cleanup:node_modules && \
    pnpm i --production --frozen-lockfile

FROM docker-remote-docker-io.art.lmru.tech/node:20.17.0-alpine as run
ARG APP
ENV APP=$APP
WORKDIR /app
RUN npm i -g --registry=https://art.lmru.tech/artifactory/api/npm/npm pnpm@9.7.1 && \
    apk --no-cache add \
    -X https://art.lmru.tech/artifactory/apk-remote-alpine/v3.18/main \
    -X https://art.lmru.tech/artifactory/apk-remote-alpine/v3.18/community \
    curl gcompat && \
    addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nodejs
COPY --from=builder --chown=nodejs:nodejs /app .
EXPOSE 3000
CMD ["pnpm", "start"]
