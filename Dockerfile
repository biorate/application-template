FROM docker.art.lmru.tech/node:14.15.1-alpine3.12

ARG APP
ENV APP=$APP

RUN env;

WORKDIR /app

COPY . .

RUN apk update && \
    apk upgrade && \
    apk add git

RUN npm ci
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
